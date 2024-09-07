import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eams/app/modules/alert/controllers/alert_controller.dart';
import 'package:eams/app/modules/geofencing/controllers/location_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eams/app/routes/app_pages.dart';
import 'package:eams/app/widgets/toast/custom_toast.dart';
import 'package:eams/company_data.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  var officeDistance = 0.0.obs;
  var totalWorkingHours = 0.0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Timer? timer;
  final LocationService _locationService = new LocationService();
  final AlertService _alertService = new AlertService();

  @override
  void onInit() {
    super.onInit();
    _startLocationUpdates();
    calculateTotalWorkingHours();
  }

  void _startLocationUpdates() {
    _locationService.startLocationStream((distance) {
      officeDistance.value = distance;
      if (distance > 200) {
        _alertService.raiseAlert(Get.context!);
      }
    });
  }

    Future<void> calculateTotalWorkingHours() async {
      String uid = auth.currentUser!.uid;
      QuerySnapshot<Map<String, dynamic>> presenceSnapshot = await firestore
          .collection("employee")
          .doc(uid)
          .collection("presence")
          .get();

      double total = 0.0;

      for (var doc in presenceSnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        if (data['masuk'] != null && data['keluar'] != null) {
          try {
            String checkInString = data['masuk']['date'] as String;
            String checkOutString = data['keluar']['date'] as String;
            
            DateTime checkIn = DateTime.parse(checkInString);
            DateTime checkOut = DateTime.parse(checkOutString);
            
            // Calculate the difference in hours
            Duration difference = checkOut.difference(checkIn);
            double hours = difference.inMinutes / 60.0;
            
            // Add to total, rounding to 2 decimal places
            total += double.parse(hours.toStringAsFixed(2));
          } catch (e) {
            print('Error calculating hours for document ${doc.id}: $e');
            // Optionally, you can add more detailed error handling here
          }
        }
      }

      totalWorkingHours.value = double.parse(total.toStringAsFixed(2));
      print('Total working hours: ${totalWorkingHours.value}');
    }
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("employee").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastPresence() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore
        .collection("employee")
        .doc(uid)
        .collection("presence")
        .orderBy("date", descending: true)
        .limitToLast(5)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresence() async* {
    String uid = auth.currentUser!.uid;
    String todayDocId =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");
    yield* firestore
        .collection("employee")
        .doc(uid)
        .collection("presence")
        .doc(todayDocId)
        .snapshots();
  }
}