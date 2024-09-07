import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:eams/app/style/app_color.dart';
import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({Key? key}) : super(key: key);

  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.employeeidC.text = user["employee_id"];
    controller.nameC.text = user["name"];
    controller.emailC.text = user["email"];

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
                    'Update Profile',
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
                  Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.secondary),
                  ),
                  const SizedBox(height: 20),
                  _buildProfileImage(),
                  const SizedBox(height: 20),
                  CustomInput(
                    controller: controller.employeeidC,
                    label: 'Employee ID',
                    hint: '1000000001',
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  CustomInput(
                    controller: controller.nameC,
                    label: 'Full Name',
                    hint: 'Your Full Name',
                  ),
                  const SizedBox(height: 16),
                  CustomInput(
                    controller: controller.emailC,
                    label: 'Email',
                    hint: 'youremail@email.com',
                    readOnly: true,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.isFalse ? controller.updateProfile : null,
                        child: Text(
                          controller.isLoading.isFalse ? 'Update Profile' : 'Updating...',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColor.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: GetBuilder<UpdateProfileController>(
        builder: (controller) {
          return Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: (controller.image != null)
                    ? FileImage(File(controller.image!.path))
                    : NetworkImage(
                        (user["avatar"] == null || user['avatar'] == "")
                            ? "https://ui-avatars.com/api/?name=${user['name']}/"
                            : user['avatar'],
                      ) as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: AppColor.primary,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () => controller.pickImage(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool readOnly;

  const CustomInput({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColor.secondary),
        hintText: hint,
        hintStyle: TextStyle(color: AppColor.primaryExtraSoft),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.secondary.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.primary),
        ),
      ),
    );
  }
}