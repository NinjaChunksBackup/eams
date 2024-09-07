import 'package:flutter/material.dart';

class AlertView extends StatelessWidget {
  final String message;
  const AlertView({Key? key, required this.message}) : super(key: key);

  Widget _buildTitle() {
    return Row(
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 28,
        ),
        SizedBox(width: 8),
        Text(
          'Alert',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(message, style: TextStyle(fontSize: 18, color: Colors.black87));
  }

  Widget _buildDismissButton(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text('Dismiss',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      title: _buildTitle(),
      content: _buildContent(context),
      actions: [_buildDismissButton(context)],
    );
  }
}
