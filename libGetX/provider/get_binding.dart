import 'package:get/get.dart';
import '../controller/address_controller.dart';

class AddressBindings extends Bindings {
  @override
  void dependencies() {
    // Lazy initialize dependencies
    // Get.lazyPut<http.Client>(() => http.Client());
    // Get.lazyPut<ApiService>(() => ApiService(Get.find<http.Client>()));
    // Get.lazyPut<AddressRepository>(() => AddressRepository(Get.find<ApiService>()));

    Get.lazyPut<AddressController>(() => AddressController());
  }
}
