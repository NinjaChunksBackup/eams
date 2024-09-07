import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:eams/app/style/app_color.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);

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
                    'Change Password',
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
                    'Security',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.secondary),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => CustomInput(
                      controller: controller.currentPassC,
                      label: 'Current Password',
                      hint: '••••••••',
                      obscureText: controller.oldPassObs.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.oldPassObs.value ? Icons.visibility_off : Icons.visibility,
                          color: AppColor.secondary,
                        ),
                        onPressed: controller.oldPassObs.toggle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CustomInput(
                      controller: controller.newPassC,
                      label: 'New Password',
                      hint: '••••••••',
                      obscureText: controller.newPassObs.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.newPassObs.value ? Icons.visibility_off : Icons.visibility,
                          color: AppColor.secondary,
                        ),
                        onPressed: controller.newPassObs.toggle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CustomInput(
                      controller: controller.confirmNewPassC,
                      label: 'Confirm New Password',
                      hint: '••••••••',
                      obscureText: controller.newPassCObs.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.newPassCObs.value ? Icons.visibility_off : Icons.visibility,
                          color: AppColor.secondary,
                        ),
                        onPressed: controller.newPassCObs.toggle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.isFalse ? controller.updatePassword : null,
                        child: Text(
                          controller.isLoading.isFalse ? "Change Password" : 'Changing...',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColor.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomInput({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColor.secondary),
        hintText: hint,
        hintStyle: TextStyle(color: AppColor.primaryExtraSoft),
        suffixIcon: suffixIcon,
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