import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../company_data.dart';
import 'dart:async';

/* This service checks whether Employee is within 200m radius */
class LocationService {
  StreamSubscription<Position>? _positionStream;
  void startLocationStream(Function(double) onDistanceChanged) {
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
    );
    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        CompanyData.office['latitude'],
        CompanyData.office['longitude'],
      );
      print('Calculated Distance: ${distance}');
      onDistanceChanged(distance);
    });
  }

  void stopLocationStream() {
    _positionStream?.cancel();
  }
}
