import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eams/app/modules/alert/controllers/alert_controller.dart';
import 'package:eams/app/modules/geofencing/controllers/location_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eams/app/widgets/toast/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:eams/app/style/app_color.dart';
import 'package:eams/app/widgets/dialog/custom_alert_dialog.dart';

class HomeController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxDouble closestDistance = 0.0.obs;
  final RxBool isNearLocation = false.obs;
  final RxDouble totalWorkingHours = 0.0.obs;
  final RxList<Map<String, dynamic>> nearbyLocations = <Map<String, dynamic>>[].obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocationService _locationService = Get.find<LocationService>();
  final AlertService _alertService = Get.find<AlertService>();

    @override
  void onInit() {
    super.onInit();
    _startLocationUpdates();
    calculateTotalWorkingHours();
    ever(_locationService.isLocationPermissionGranted, _handlePermissionChange);
    ever(_locationService.isLocationServiceEnabled, _handleServiceChange);
  }

  void _handlePermissionChange(bool isGranted) {
    if (!isGranted) {
      _alertService.raiseAlert(Get.context!, 
        customMessage: 'Location permission is required for attendance. Please grant permission in settings.');
    }
  }

  void _handleServiceChange(bool isEnabled) {
    if (!isEnabled) {
      _alertService.raiseAlert(Get.context!, 
        customMessage: 'Location service is disabled. Please enable it for accurate attendance tracking.');
    }
  }

  void _startLocationUpdates() {
    _locationService.startLocationStream((distance, isNear) {
      closestDistance.value = distance;
      isNearLocation.value = isNear;
      if (!isNear && distance > 200) {
        _alertService.raiseAlert(Get.context!, 
          customMessage: 'You are not near any registered work location. Please move to a designated work area.');
      }
    });
  }


  Future<void> calculateTotalWorkingHours() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final presenceSnapshot = await _firestore
          .collection("employee")
          .doc(uid)
          .collection("presence")
          .get();

      double total = 0.0;

      for (var doc in presenceSnapshot.docs) {
        final data = doc.data();
        final checkIn = data['masuk']?['date'];
        final checkOut = data['keluar']?['date'];

        if (checkIn != null && checkOut != null) {
          final difference = DateTime.parse(checkOut).difference(DateTime.parse(checkIn));
          total += difference.inMinutes / 60.0;
        }
      }

      totalWorkingHours.value = double.parse(total.toStringAsFixed(2));
      debugPrint('Total working hours: ${totalWorkingHours.value}');
    } catch (e) {
      debugPrint('Error calculating total working hours: $e');
    }
  }

  Future<bool> hasFaceRegistered() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    final doc = await _firestore.collection("employees").doc(uid).get();
    return doc.exists && (doc.data() as Map<String, dynamic>?)?.containsKey('faceFeatures') == true;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return Stream.empty();
    }
    return _firestore.collection("employee").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastPresence() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return Stream.empty();
    }
    return _firestore
        .collection("employee")
        .doc(uid)
        .collection("presence")
        .orderBy("date", descending: true)
        .limit(3)  // Changed from limitToLast(5) to limit(3)
        .snapshots();
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresence() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return Stream.empty();
    }
    final todayDocId = DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");
    return _firestore
        .collection("employee")
        .doc(uid)
        .collection("presence")
        .doc(todayDocId)
        .snapshots();
  }

  Future<void> checkNearbyLocations() async {
    if (!_locationService.isLocationPermissionGranted.value) {
      await _locationService.checkLocationPermissionAndService();
      if (!_locationService.isLocationPermissionGranted.value) {
        CustomToast.errorToast('Permission Denied', 'Location permission is required for attendance.');
        return;
      }
    }

    if (!_locationService.isLocationServiceEnabled.value) {
      await _locationService.checkLocationPermissionAndService();
      if (!_locationService.isLocationServiceEnabled.value) {
        CustomToast.errorToast('Service Disabled', 'Please enable location services for attendance.');
        return;
      }
    }

    isLoading.value = true;
    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      nearbyLocations.value = _locationService.getNearbyLocations(position);
      if (nearbyLocations.isNotEmpty) {
        _showLocationSelectionDialog();
      } else {
        CustomToast.errorToast('No nearby locations', 'You are not within range of any work location.');
      }
    } catch (e) {
      CustomToast.errorToast('Error', 'Failed to get your location. Please try again.');
      debugPrint('Error getting location: $e');
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
                  title: Text(location['name'] ?? '', style: TextStyle(color: AppColor.secondary, fontWeight: FontWeight.w600)),
                  subtitle: Text("${location['distance']?.toStringAsFixed(2) ?? ''} meters", style: TextStyle(color: AppColor.secondarySoft)),
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
      message: "Use ${location['name'] ?? 'Unknown'}?",
      onCancel: () => Get.back(),
      onConfirm: () {
        Get.back();
        _processPresence(location);
      },
    );
  }

   Future<void> _processPresence(Map<String, dynamic> selectedLocation) async {
    isLoading.value = true;
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        CustomToast.errorToast('Error', 'User not authenticated');
        return;
      }

      final todayDocId = DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");
      final presenceRef = _firestore.collection("employee").doc(uid).collection("presence").doc(todayDocId);
      final snapshot = await presenceRef.get();

      if (!snapshot.exists) {
        await _checkIn(presenceRef, selectedLocation);
      } else if (snapshot.data()?['keluar'] == null) {
        await _checkOut(presenceRef, selectedLocation);
      } else {
        CustomToast.errorToast('Error', 'You have already completed your presence for today');
      }
    } catch (e) {
      CustomToast.errorToast('Error', 'Failed to process presence. Please try again.');
      debugPrint('Error processing presence: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _checkIn(DocumentReference<Map<String, dynamic>> presenceRef, Map<String, dynamic> selectedLocation) async {
    await presenceRef.set({
      "date": DateTime.now().toIso8601String(),
      "masuk": {
        "date": DateTime.now().toIso8601String(),
        "latitude": selectedLocation['latitude'],
        "longitude": selectedLocation['longitude'],
        "location": selectedLocation['name'],
        "distance": selectedLocation['distance'],
      }
    });
    CustomToast.successToast('Success', 'Check-in successful');
  }

  Future<void> _checkOut(DocumentReference<Map<String, dynamic>> presenceRef, Map<String, dynamic> selectedLocation) async {
    await presenceRef.update({
      "keluar": {
        "date": DateTime.now().toIso8601String(),
        "latitude": selectedLocation['latitude'],
        "longitude": selectedLocation['longitude'],
        "location": selectedLocation['name'],
        "distance": selectedLocation['distance'],
      }
    });
    CustomToast.successToast('Success', 'Check-out successful');
  }
}