import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:eams/app/controllers/page_index_controller.dart';
import 'package:eams/app/routes/app_pages.dart';
import 'package:eams/app/style/app_color.dart';
import 'package:eams/app/widgets/custom_bottom_navigation_bar.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageIndexController = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return Center(child: Text('No user data available'));
          }

          Map<String, dynamic> userData = snapshot.data!.data()!;
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 250, // Increased height to accommodate lower placement
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildProfileHeader(userData),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildProfileMenu(context, userData),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> userData) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 30), // Added top padding to move content down
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  (userData["avatar"] == null || userData['avatar'] == "")
                      ? "https://ui-avatars.com/api/?name=${userData['name']}/"
                      : userData['avatar'],
                ),
              ),
              SizedBox(height: 16),
              Text(
                userData["name"],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8), // Added space between name and job title
              Text(
                userData["job"].toString().replaceFirst(userData["job"][0], userData["job"][0].toUpperCase()),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context, Map<String, dynamic> userData) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.secondary,
            ),
          ),
          SizedBox(height: 16),
          _buildMenuTile(
            title: 'Update Profile',
            icon: 'assets/icons/profile-1.svg',
            onTap: () => Get.toNamed(Routes.UPDATE_POFILE, arguments: userData),
          ),
          if (userData["role"] == "admin")
            _buildMenuTile(
              title: 'Add Employee',
              icon: 'assets/icons/people.svg',
              onTap: () => Get.toNamed(Routes.ADD_EMPLOYEE),
            ),
          _buildMenuTile(
            title: 'Change Password',
            icon: 'assets/icons/password.svg',
            onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
          ),
          _buildMenuTile(
            title: 'Sign Out',
            icon: 'assets/icons/logout.svg',
            onTap: controller.logout,
            isDanger: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required String title,
    required String icon,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDanger ? AppColor.primaryExtraSoft : AppColor.primaryExtraSoft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
          icon,
          color: isDanger ? AppColor.error : AppColor.primary,
          width: 24,
          height: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDanger ? AppColor.error : AppColor.secondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDanger ? AppColor.error : AppColor.secondary,
      ),
      onTap: onTap,
    );
  }
}