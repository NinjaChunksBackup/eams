import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:eams/app/routes/app_pages.dart';
import 'package:eams/app/style/app_color.dart';

import '../controllers/login_controller.dart';
import '../../../widgets/logo_widget.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.primary,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                image: DecorationImage(
                  image: AssetImage('assets/images/pattern-1-1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.only(
                left: 32,
                top: MediaQuery.of(context).padding.top,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LogoWidget(height: 60, width: 150),
                  SizedBox(height: 10),
                  Text(
                    "THE ASCENDANTS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 24),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity, // Ensure it spans full width
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: AppColor.secondaryExtraSoft),
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: 14, fontFamily: 'poppins'),
                      maxLines: 1,
                      controller: controller.emailC,
                      decoration: InputDecoration(
                        label: Text(
                          "Email",
                          style: TextStyle(
                            color: AppColor.secondarySoft,
                            fontSize: 14,
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: InputBorder.none,
                        hintText: "youremail@email.com",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                          color: AppColor.secondarySoft,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    child: Container(
                      width: double.infinity, // Ensure it spans full width
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      margin: EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: AppColor.secondaryExtraSoft),
                      ),
                      child: Obx(
                        () => TextField(
                          style: TextStyle(fontSize: 14, fontFamily: 'poppins'),
                          maxLines: 1,
                          controller: controller.passC,
                          obscureText: controller.obsecureText.value,
                          decoration: InputDecoration(
                            label: Text(
                              "Password",
                              style: TextStyle(
                                color: AppColor.secondarySoft,
                                fontSize: 14,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: InputBorder.none,
                            hintText: "*************",
                            suffixIcon: IconButton(
                              icon: controller.obsecureText.value
                                  ? SvgPicture.asset('assets/icons/show.svg')
                                  : SvgPicture.asset('assets/icons/hide.svg'),
                              onPressed: () {
                                controller.obsecureText.value = !controller.obsecureText.value;
                              },
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                              color: AppColor.secondarySoft,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Container(
                      width: double.infinity, // Ensure it spans full width
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!controller.isLoading.value) {
                            await controller.login();
                          }
                        },
                        child: Text(
                          controller.isLoading.value ? 'Loading...' : 'Log in',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                          primary: AppColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity, // Ensure it spans full width
                    margin: EdgeInsets.only(top: 4),
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                      child: Text("Forgot your password?"),
                      style: TextButton.styleFrom(
                        primary: AppColor.secondarySoft,
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