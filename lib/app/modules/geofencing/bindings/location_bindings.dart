import 'package:get/get.dart';
import '../controllers/location_service.dart';

class LocationBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LocationService(), permanent: true);
  }
}
