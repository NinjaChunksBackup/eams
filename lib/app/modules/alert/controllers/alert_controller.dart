import 'package:flutter/material.dart';
import '../views/alert_view.dart';

class AlertService {
  void raiseAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertView(
          message:
              'You are outside the 200m radius of the office! Please enter the premises as soon as possible.',
        );
      },
    );
  }
}
