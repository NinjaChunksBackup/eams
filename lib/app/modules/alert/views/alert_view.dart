import 'package:flutter/material.dart';
import 'package:eams/app/style/app_color.dart';

class AlertView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onDismiss;

  const AlertView({
    Key? key,
    this.title = 'Alert',
    required this.message,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColor.error,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 18, color: Colors.black87),
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: Text(
            'Dismiss',
            style: TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}