import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eams/app/routes/app_pages.dart';
import 'package:eams/app/style/app_color.dart';
import 'package:eams/app/widgets/custom_bottom_navigation_bar.dart';
import 'package:eams/app/widgets/presence_card.dart';
import 'package:eams/app/widgets/presence_tile.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      extendBody: true,
      body: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: () async {
          await controller.calculateTotalWorkingHours(); // Refresh total working hours
          // Optionally refresh other streams if necessary
        },
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.done:
                Map<String, dynamic> user = snapshot.data!.data()!;
                return ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 36),
                  children: [
                    SizedBox(height: 16),
                    // Section 1 - Welcome Back
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 42,
                              height: 42,
                              child: Image.network(
                                (user["avatar"] == null || user['avatar'] == "")
                                    ? "https://ui-avatars.com/api/?name=${user['name']}/"
                                    : user['avatar'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.secondaryExtraSoft,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                user["name"],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'poppins',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Section 2 - Card
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.streamTodayPresence(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                          case ConnectionState.done:
                            var todayPresenceData = snapshot.data?.data();
                            return PresenceCard(
                              userData: user,
                              todayPresenceData: todayPresenceData,
                            );
                          default:
                            return SizedBox();
                        }
                      },
                    ),
                    // Last location
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 24, left: 4),
                      child: Text(
                        (user["address"] != null)
                            ? "${user['address']}"
                            : "Belum ada lokasi",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.secondaryExtraSoft,
                        ),
                      ),
                    ),
                    // Section 3 - Distance & Total Working Hours
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 84,
                              decoration: BoxDecoration(
                                color: AppColor.primaryExtraSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      'Distance from office',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      controller.officeDistance.value > 200
                                          ? 'Exceeded'
                                          : '${controller.officeDistance.value.toStringAsFixed(2)} m',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 84,
                              decoration: BoxDecoration(
                                color: AppColor.primaryExtraSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      'Total Working Hours',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      '${controller.totalWorkingHours.value} hrs',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Section 4 - Presence History
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Presence History",
                            style: TextStyle(
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(Routes.ALL_PRESENCE),
                            child: Text("Show All"),
                            style: TextButton.styleFrom(
                              primary: AppColor.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller.streamLastPresence(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                          case ConnectionState.done:
                            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                listPresence = snapshot.data!.docs;
                            return ListView.separated(
                              itemCount: listPresence.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                Map<String, dynamic> presenceData =
                                    listPresence[index].data();
                                return PresenceTile(
                                  presenceData: presenceData,
                                );
                              },
                            );
                          default:
                            return SizedBox();
                        }
                      },
                    ),
                  ],
                );

              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return Center(child: Text("Error"));
            }
          },
        ),
      ),
    );
  }
}