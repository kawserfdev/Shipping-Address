import 'package:get/get.dart';
import '../controller/address_controller.dart';
class AddressBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AddressController>(AddressController(), permanent: true);
  }
}