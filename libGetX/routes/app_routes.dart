import 'package:get/get.dart';
import '../getmodel/address_model.dart';
import '../provider/get_binding.dart';
import '../view/address_book_page.dart';
import '../view/shipping_address_get_page.dart';

class Routes {
  static const String initial = '/address_book';
  static const String address = '/address';

  static List<GetPage> pages = [
    GetPage(
      name: initial,
      page: () => MyAddressBook(),
      binding: AddressBindings(),
    ),
    GetPage(
      name: address,
      page: () {
        final AddressModel? model = Get.arguments as AddressModel?;
        return ShippingAddressPage(address: model ?? AddressModel());
      },
      binding: AddressBindings(),
    ),
  ];
}




