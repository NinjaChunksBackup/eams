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
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      extendBody: true,
      body: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: () => controller.calculateTotalWorkingHours(),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: AppColor.primary));
            }
            if (!snapshot.hasData || snapshot.hasError) {
              return Center(child: Text("Error loading user data", style: TextStyle(color: AppColor.error)));
            }
            final user = snapshot.data!.data()!;
            return _buildHomeContent(context, user);
          },
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, Map<String, dynamic> user) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      children: [
        const SizedBox(height: 16),
        _buildWelcomeSection(user),
        _buildPresenceCard(user),
        _buildLocationInfo(user),
        _buildStatistics(),
        _buildPresenceHistory(),
      ],
    );
  }

  Widget _buildWelcomeSection(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          const SizedBox(width: 24),
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
              const SizedBox(height: 4),
              Text(
                user["name"],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresenceCard(Map<String, dynamic> user) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: controller.streamTodayPresence(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final todayPresenceData = snapshot.data?.data();
        return PresenceCard(
          userData: user,
          todayPresenceData: todayPresenceData,
        );
      },
    );
  }

  Widget _buildLocationInfo(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 24, left: 4),
      child: Text(
        user["address"] ?? "No location data",
        style: TextStyle(
          fontSize: 12,
          color: AppColor.secondaryExtraSoft,
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _buildStatisticCard(
            'Nearest location',
            controller.closestDistance,
            (value) => controller.isNearLocation.value
                ? '${value.toStringAsFixed(2)} m'
                : 'Too far',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatisticCard(
            'Total Working Hours',
            controller.totalWorkingHours,
            (value) => '${value.toStringAsFixed(2)} hrs',
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticCard(String title, RxDouble value, String Function(double) formatter) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: AppColor.primaryExtraSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Obx(() => Text(
            formatter(value.value),
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          )),
        ],
      ),
    );
  }

  Widget _buildPresenceHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Presence History",
              style: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(Routes.ALL_PRESENCE),
              child: const Text("Show All"),
              style: TextButton.styleFrom(
                primary: AppColor.primary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamLastPresence(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No presence data available"));
            }
            final listPresence = snapshot.data!.docs;
            return ListView.separated(
              itemCount: listPresence.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final presenceData = listPresence[index].data();
                return PresenceTile(presenceData: presenceData);
              },
            );
          },
        ),
      ],
    );
  }
}