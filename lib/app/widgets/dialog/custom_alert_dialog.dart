import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eams/app/style/app_color.dart';
import 'package:eams/app/widgets/custom_input.dart';

class CustomAlertDialog {
  static void _showDialog({
    required String title,
    required String message,
    required List<Widget> actions,
    Widget? extraContent,
  }) {
    Get.defaultDialog(
      title: "",
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      radius: 8,
      titlePadding: EdgeInsets.zero,
      titleStyle: TextStyle(fontSize: 0),
      content: Column(
        children: [
          _buildDialogHeader(title, message),
          if (extraContent != null) extraContent,
          _buildActionButtons(actions),
        ],
      ),
    );
  }

  static Widget _buildDialogHeader(String title, String message) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 16), // Add left padding to indent the message
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: AppColor.secondarySoft,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildActionButtons(List<Widget> actions) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: actions.map((action) => Expanded(child: action)).toList(),
      ),
    );
  }

  static void confirmAdmin({
    required String title,
    required String message,
    required void Function() onConfirm,
    required void Function() onCancel,
    required TextEditingController controller,
  }) {
    _showDialog(
      title: title,
      message: message,
      extraContent: CustomInput(
        margin: EdgeInsets.only(bottom: 24),
        controller: controller,
        label: 'password',
        hint: '*************',
        obsecureText: true,
      ),
      actions: [
        _buildButton("Cancel", AppColor.primaryExtraSoft, AppColor.secondarySoft, onCancel),
        SizedBox(width: 16),
        _buildButton("Confirm", AppColor.primary, Colors.white, onConfirm),
      ],
    );
  }

    static void showPresenceAlert({
    required String title,
    required String message,
    required void Function() onConfirm,
    required void Function() onCancel,
  }) {
    Get.defaultDialog(
      title: "",
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      radius: 8,
      titlePadding: EdgeInsets.zero,
      titleStyle: TextStyle(fontSize: 0),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Ensure left alignment
        children: [
          _buildDialogHeader(title, message),
          _buildActionButtons([
            _buildButton("Cancel", AppColor.primaryExtraSoft, AppColor.secondarySoft, onCancel),
            SizedBox(width: 16),
            _buildButton("Confirm", AppColor.primary, Colors.white, onConfirm),
          ]),
        ],
      ),
    );
  }

  static Widget _buildButton(String label, Color backgroundColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 12),
        elevation: 0,
      ),
    );
  }
}