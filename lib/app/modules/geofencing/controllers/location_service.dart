import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'dart:async';
import 'package:eams/company_data.dart';
import 'package:get/get.dart';
import 'package:eams/app/widgets/dialog/custom_alert_dialog.dart';
import 'package:eams/app/style/app_color.dart';

class LocationService extends GetxController {
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<ServiceStatus>? _serviceStatusStream;
  final _locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 2,
  );

  final RxBool isLocationServiceEnabled = false.obs;
  final RxBool isLocationPermissionGranted = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLocationPermissionAndService();
    _listenToServiceStatus();
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    _serviceStatusStream?.cancel();
    super.onClose();
  }

  Future<void> checkLocationPermissionAndService() async {
    await _checkLocationPermission();
    await _checkLocationService();
  }

  Future<void> _checkLocationPermission() async {
    final status = await ph.Permission.location.status;
    isLocationPermissionGranted.value = status.isGranted;
    if (!isLocationPermissionGranted.value) {
      _requestLocationPermission();
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await ph.Permission.location.request();
    isLocationPermissionGranted.value = status.isGranted;
    if (!isLocationPermissionGranted.value) {
      CustomAlertDialog.showPresenceAlert(
        title: 'Location Permission Required',
        message: 'This app needs location permission to function properly. Please grant the permission in app settings.',
        onCancel: () => Get.back(),
        onConfirm: () => ph.openAppSettings(),
      );
    }
  }

  Future<void> _checkLocationService() async {
    isLocationServiceEnabled.value = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled.value) {
      _requestLocationService();
    }
  }

  Future<void> _requestLocationService() async {
    CustomAlertDialog.showPresenceAlert(
      title: 'Location Service Required',
      message: 'Please enable location services to use this app.',
      onCancel: () => Get.back(),
      onConfirm: () async {
        await Geolocator.openLocationSettings();
        Get.back();
        await _checkLocationService();
      },
    );
  }

  void _listenToServiceStatus() {
    _serviceStatusStream = Geolocator.getServiceStatusStream().listen(
      (ServiceStatus status) {
        isLocationServiceEnabled.value = (status == ServiceStatus.enabled);
        if (!isLocationServiceEnabled.value) {
          _requestLocationService();
        }
      },
    );
  }

  Future<void> startLocationStream(Function(double, bool) onLocationChanged) async {
    if (!isLocationPermissionGranted.value || !isLocationServiceEnabled.value) {
      await checkLocationPermissionAndService();
    }

    if (isLocationPermissionGranted.value && isLocationServiceEnabled.value) {
      _positionStream = Geolocator.getPositionStream(locationSettings: _locationSettings)
          .listen(
        (Position position) => _handlePositionUpdate(position, onLocationChanged),
        onError: (error) => debugPrint('Error occurred while getting position: $error'),
      );
    }
  }

  void stopLocationStream() {
    _positionStream?.cancel();
  }

  List<Map<String, dynamic>> getNearbyLocations(Position position) {
    final List<Map<String, dynamic>> nearbyLocations = [];
    final allLocations = CompanyData.allLocations;

    for (final location in allLocations) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        location['latitude'],
        location['longitude'],
      );

      if (distance <= 200) {
        nearbyLocations.add({
          'name': location['name'],
          'latitude': location['latitude'],
          'longitude': location['longitude'],
          'distance': distance,
        });
      }
    }

    return nearbyLocations;
  }

  void _handlePositionUpdate(Position position, Function(double, bool) onLocationChanged) {
    final nearbyLocations = getNearbyLocations(position);
    final isNearAnyLocation = nearbyLocations.isNotEmpty;
    
    double closestDistance = double.infinity;
    if (isNearAnyLocation) {
      closestDistance = nearbyLocations
          .map((loc) => loc['distance'] as double)
          .reduce((a, b) => a < b ? a : b);
    } else {
      closestDistance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        CompanyData.mainOffice['latitude'],
        CompanyData.mainOffice['longitude'],
      );
    }

    debugPrint('Closest Distance: $closestDistance, Near Any Location: $isNearAnyLocation');
    onLocationChanged(closestDistance, isNearAnyLocation);
  }
}