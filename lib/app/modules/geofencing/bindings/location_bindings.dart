import 'package:get/get.dart';
import '../controllers/location_service.dart';

class LocationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationService>(() => LocationService());
  }
}
