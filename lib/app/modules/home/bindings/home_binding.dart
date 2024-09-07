import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../geofencing/controllers/location_service.dart';
import '../../alert/controllers/alert_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<LocationService>(() => LocationService());
    Get.lazyPut<AlertService>(() => AlertService());
  }
}
