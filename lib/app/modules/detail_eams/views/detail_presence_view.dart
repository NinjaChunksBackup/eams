import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eams/app/style/app_color.dart';

import '../controllers/detail_presence_controller.dart';

class DetailPresenceView extends GetView<DetailPresenceController> {
  final Map<String, dynamic> presenceData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final top = constraints.biggest.height;
                final expandedHeight = MediaQuery.of(context).padding.top + 120;
                final shrinkOffset = 1 - ((top - kToolbarHeight) / (expandedHeight - kToolbarHeight)).clamp(0.0, 1.0);

                return FlexibleSpaceBar(
                  title: Text(
                    'Presence Detail',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  titlePadding: EdgeInsetsDirectional.only(
                    start: 16 + 56 * shrinkOffset, // Keep the original positioning logic
                    bottom: 16,
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                    ),
                  ),
                );
              },
            ),
            leading: IconButton(
              icon: SvgPicture.asset('assets/icons/arrow-left.svg', color: Colors.white),
              onPressed: () => Get.back(),
            ),
            backgroundColor: AppColor.primary,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Presence Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.secondary),
                  ),
                  SizedBox(height: 20),
                  // check in ============================================
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColor.primaryExtraSoft,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.secondaryExtraSoft, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check in',
                                  style: TextStyle(color: AppColor.secondaryExtraSoft),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  (presenceData["masuk"] == null) ? "-" : "${DateFormat.jm().format(DateTime.parse(presenceData["masuk"]["date"]))}",
                                  style: TextStyle(color: AppColor.secondaryExtraSoft, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            //presence date
                            Text(
                              "${DateFormat.yMMMMEEEEd().format(DateTime.parse(presenceData["date"]))}",
                              style: TextStyle(color: AppColor.secondaryExtraSoft),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Status',
                          style: TextStyle(color: AppColor.secondaryExtraSoft),
                        ),
                        SizedBox(height: 4),
                        Text(
                          (presenceData["masuk"]?["in_area"] == true) ? "In area presence" : "Outside area presence",
                          style: TextStyle(color: AppColor.secondaryExtraSoft, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Address',
                          style: TextStyle(color: AppColor.secondaryExtraSoft),
                        ),
                        SizedBox(height: 4),
                        Text(
                          (presenceData["masuk"] == null) ? "-" : "${presenceData["masuk"]["address"]}",
                          style: TextStyle(
                            color: AppColor.secondaryExtraSoft,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 150 / 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  // check out ===========================================
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.secondaryExtraSoft, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check out',
                                  style: TextStyle(color: AppColor.secondary),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  (presenceData["keluar"] == null) ? "-" : "${DateFormat.jm().format(DateTime.parse(presenceData["keluar"]["date"]))}",
                                  style: TextStyle(color: AppColor.secondary, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            //presence date
                            Text(
                              "${DateFormat.yMMMMEEEEd().format(DateTime.parse(presenceData["date"]))}",
                              style: TextStyle(color: AppColor.secondary),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Status',
                          style: TextStyle(color: AppColor.secondary),
                        ),
                        SizedBox(height: 4),
                        Text(
                          (presenceData["keluar"]?["in_area"] == true) ? "In area presence" : "Outside area presence",
                          style: TextStyle(color: AppColor.secondary, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Address',
                          style: TextStyle(color: AppColor.secondary),
                        ),
                        SizedBox(height: 4),
                        Text(
                          (presenceData["keluar"] == null) ? "-" : "${presenceData["keluar"]["address"]}",
                          style: TextStyle(
                            color: AppColor.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 150 / 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}