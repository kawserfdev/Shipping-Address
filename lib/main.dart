import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'provider/get_binding.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  AddressBindings().dependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shipping',
      initialRoute: Routes.initial,
      getPages: Routes.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
