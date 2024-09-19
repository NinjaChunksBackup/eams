import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eams/app/widgets/dialog/custom_alert_dialog.dart';
import 'package:eams/app/widgets/toast/custom_toast.dart';
import 'package:eams/company_data.dart';
import 'package:eams/app/modules/geofencing/controllers/location_service.dart';
import 'package:flutter/material.dart';
import 'package:eams/app/style/app_color.dart';

class PresenceController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> nearbyLocations = <Map<String, dynamic>>[].obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocationService _locationService = LocationService();

  Future<void> checkNearbyLocations() async {
    isLoading.value = true;
    try {
      final positionData = await _determinePosition();
      if (!positionData["error"]) {
        final position = positionData["position"] as Position;
        nearbyLocations.value = _locationService.getNearbyLocations(position);
        
        if (nearbyLocations.isNotEmpty) {
          _showLocationSelectionDialog();
        } else {
          CustomToast.errorToast('No nearby locations', 'You are not within range of any work location.');
        }
      }
    } catch (e) {
      CustomToast.errorToast('Error', 'Failed to get your location. Please try again.');
      print('Error getting location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _showLocationSelectionDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Select Location", style: TextStyle(color: AppColor.secondary, fontWeight: FontWeight.bold)),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: nearbyLocations.length,
            itemBuilder: (context, index) {
              final location = nearbyLocations[index];
              return Card(
                color: AppColor.primaryExtraSoft,
                child: ListTile(
                  title: Text(location['name'], style: TextStyle(color: AppColor.secondary, fontWeight: FontWeight.w600)),
                  subtitle: Text("${location['distance'].toStringAsFixed(2)} meters", style: TextStyle(color: AppColor.secondarySoft)),
                  leading: Icon(Icons.location_on, color: AppColor.primary),
                  onTap: () => _confirmLocationSelection(location),
                ),
              );
            },
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: AppColor.background,
      ),
    );
  }

  void _confirmLocationSelection(Map<String, dynamic> location) {
    Get.back();
    CustomAlertDialog.showPresenceAlert(
      title: "Confirm Location",
      message: "Use ${location['name']}?",
      onCancel: () => Get.back(),
      onConfirm: () {
        Get.back();
        presence(selectedLocation: location);
      },
    );
  }


  Future<void> presence({Map<String, dynamic>? selectedLocation}) async {
    isLoading.value = true;
    try {
      final positionData = await _determinePosition();
      
      if (!positionData["error"]) {
        final position = positionData["position"] as Position;
        final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        final address = "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}";

        final distance = Geolocator.distanceBetween(
          selectedLocation?['latitude'] ?? CompanyData.mainOffice['latitude'],
          selectedLocation?['longitude'] ?? CompanyData.mainOffice['longitude'],
          position.latitude,
          position.longitude,
        );

        await _updatePosition(position, address);
        await _processPresence(position, address, distance, selectedLocation);
      } else {
        CustomToast.errorToast("Error", positionData["message"]);
      }
    } catch (e) {
      CustomToast.errorToast("Error", "An error occurred. Please try again.");
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _processPresence(Position position, String address, double distance, Map<String, dynamic>? selectedLocation) async {
    final uid = _auth.currentUser!.uid;
    final todayDocId = DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");

    final presenceCollection = _firestore.collection("employee").doc(uid).collection("presence");
    final todayDoc = await presenceCollection.doc(todayDocId).get();

    final inArea = distance <= 200;

    if (!todayDoc.exists) {
      await _firstPresence(presenceCollection, todayDocId, position, address, distance, inArea, selectedLocation);
    } else {
      final dataPresenceToday = todayDoc.data();
      if (dataPresenceToday?["keluar"] != null) {
        CustomToast.successToast("Success", "You have already checked in and out for today");
      } else {
        await _checkoutPresence(presenceCollection, todayDocId, position, address, distance, inArea, selectedLocation);
      }
    }
  }

  Future<void> _updatePosition(Position position, String address) async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection("employee").doc(uid).update({
      "position": {
        "latitude": position.latitude,
        "longitude": position.longitude,
      },
      "address": address,
    });
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {"message": "Location services are disabled.", "error": true};
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {"message": "Location permission denied", "error": true};
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {"message": "Location permissions permanently denied", "error": true};
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return {"position": position, "message": "Position acquired", "error": false};
  }

  Future<void> _firstPresence(
    CollectionReference<Map<String, dynamic>> presenceCollection,
    String todayDocId,
    Position position,
    String address,
    double distance,
    bool inArea,
    Map<String, dynamic>? selectedLocation,
  ) async {
    CustomAlertDialog.showPresenceAlert(
      title: "Do you want to check in?",
      message: "You are about to check in at ${selectedLocation?['name'] ?? 'your current location'}",
      onCancel: () => Get.back(),
      onConfirm: () async {
        await presenceCollection.doc(todayDocId).set(
          {
            "date": DateTime.now().toIso8601String(),
            "masuk": {
              "date": DateTime.now().toIso8601String(),
              "latitude": position.latitude,
              "longitude": position.longitude,
              "address": address,
              "in_area": inArea,
              "distance": distance,
              "location_name": selectedLocation?['name'] ?? "Main Office",
            }
          },
        );
        Get.back();
        CustomToast.successToast("Success", "Successfully checked in");
      },
    );
  }

  Future<void> _checkoutPresence(
    CollectionReference<Map<String, dynamic>> presenceCollection,
    String todayDocId,
    Position position,
    String address,
    double distance,
    bool inArea,
    Map<String, dynamic>? selectedLocation,
  ) async {
    CustomAlertDialog.showPresenceAlert(
      title: "Do you want to check out?",
      message: "You are about to check out from ${selectedLocation?['name'] ?? 'your current location'}",
      onCancel: () => Get.back(),
      onConfirm: () async {
        await presenceCollection.doc(todayDocId).update(
          {
            "keluar": {
              "date": DateTime.now().toIso8601String(),
              "latitude": position.latitude,
              "longitude": position.longitude,
              "address": address,
              "in_area": inArea,
              "distance": distance,
              "location_name": selectedLocation?['name'] ?? "Main Office",
            }
          },
        );
        Get.back();
        CustomToast.successToast("Success", "Successfully checked out");
      },
    );
  }
}