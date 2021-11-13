import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'app/modules/splash/splash_binding.dart';
import 'app/modules/splash/splash_page.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/dependecy_injection.dart';

main() {
  DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      initialBinding: SplashBinding(),
      getPages: AppPages.pages,
    );
  }
}
