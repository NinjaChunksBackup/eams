import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eams/app/routes/app_pages.dart';
import 'package:eams/app/style/app_color.dart';

class PresenceTile extends StatelessWidget {
  final Map<String, dynamic> presenceData;
  PresenceTile({required this.presenceData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.DETAIL_PRESENCE, arguments: presenceData),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: AppColor.primaryExtraSoft,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeColumn("check in", presenceData["masuk"]),
                _buildTimeColumn("check out", presenceData["keluar"]),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "${DateFormat.yMMMMEEEEd().format(DateTime.parse(presenceData["date"]))}",
              style: TextStyle(
                fontSize: 12,
                color: AppColor.secondarySoft,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(String label, dynamic data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(height: 4),
        Text(
          (data == null) ? "-" : "${DateFormat.jm().format(DateTime.parse(data["date"]))}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}