import 'package:flutter/material.dart';
import '../views/alert_view.dart';

class AlertService {
  void raiseAlert(BuildContext context, String message) {
    if (Navigator.of(context).canPop()) return;
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
