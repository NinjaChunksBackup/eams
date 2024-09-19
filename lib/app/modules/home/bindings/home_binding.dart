import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../alert/controllers/alert_controller.dart';
import '../../geofencing/controllers/location_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocationService(), permanent: true);
    Get.put(AlertService(), permanent: true);
    Get.put(HomeController());
  }
}