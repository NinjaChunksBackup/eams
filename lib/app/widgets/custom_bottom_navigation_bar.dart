import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:eams/app/controllers/page_index_controller.dart';
import 'package:eams/app/controllers/presence_controller.dart';
import 'package:eams/app/style/app_color.dart';
import 'package:eams/app/modules/home/controllers/home_controller.dart';
class CustomBottomNavigationBar extends GetView<PageIndexController> {
  CustomBottomNavigationBar({Key? key}) : super(key: key);

  final PresenceController presenceController = Get.find<PresenceController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 97,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment(0.0, 1.0),
        children: [
          _buildBottomAppBar(context),
          _buildFloatingActionButton(),
        ],
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 65,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColor.primaryExtraSoft, width: 1),
          ),
        ),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(0, 'home', 'Home'),
              _buildCenterItem(context),
              _buildNavItem(2, 'profile', 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconName, String label) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.changePage(index),
        child: Container(
          height: 65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => SvgPicture.asset(
                'assets/icons/$iconName${controller.pageIndex.value == index ? '-active' : ''}.svg',
              )),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColor.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      margin: EdgeInsets.only(top: 24),
      alignment: Alignment.center,
      child: Text(
        "EAMS",
        style: TextStyle(
          fontSize: 10,
          color: AppColor.secondary,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
  return Positioned(
    bottom: 32,
    child: Obx(
      () => SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          onPressed: () async {
            final homeController = Get.find<HomeController>();
            await homeController.checkNearbyLocations();
          },
          elevation: 0,
          backgroundColor: AppColor.primary,
          child: presenceController.isLoading.value
              ? CircularProgressIndicator(color: Colors.white)
              : SvgPicture.asset(
                  'assets/icons/fingerprint.svg',
                  color: Colors.white,
                ),
        ),
      ),
    ),
  );
}
}