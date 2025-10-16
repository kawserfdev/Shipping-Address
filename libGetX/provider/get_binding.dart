import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../address_repository/address_repository.dart';
import '../controller/address_controller.dart';
import '../getservice/api_service.dart';

class AddressBindings extends Bindings {
  @override
  void dependencies() {
    // Lazy initialize dependencies
    Get.lazyPut<http.Client>(() => http.Client());
    Get.lazyPut<ApiService>(() => ApiService(Get.find<http.Client>()));
    Get.lazyPut<AddressRepository>(() => AddressRepository(Get.find<ApiService>()));

    Get.lazyPut<AddressController>(
      () => AddressController(Get.find<AddressRepository>()),
      fenix: true,
    );
  }
}



