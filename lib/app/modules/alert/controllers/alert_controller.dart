import 'package:flutter/material.dart';
import '../views/alert_view.dart';

class AlertService {
  void raiseAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertView(
          message: message,
        );
      },
    );
  }
}
