import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/alert_view.dart';

class AlertService extends GetxService {
  final RxBool _isAlertShowing = false.obs;
  final RxString _currentAlertMessage = ''.obs;

  void raiseAlert(BuildContext context, {String? customMessage}) {
    if (Navigator.of(context).canPop()) return;

    if (_isAlertShowing.value) {
      _currentAlertMessage.value = customMessage ??
          'You are outside the 200m radius of the office! Please enter the premises as soon as possible.';
    } else {
      _isAlertShowing.value = true;
      _currentAlertMessage.value = customMessage ??
          'You are outside the 200m radius of the office! Please enter the premises as soon as possible.';
      _showAlert(context);
    }
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Obx(() => AlertView(
              message: _currentAlertMessage.value,
              onDismiss: () {
                _isAlertShowing.value = false;
                Navigator.of(context).pop();
              },
            ));
      },
    ).then((_) => _isAlertShowing.value = false);
  }
}
