import 'package:speech_app/app/modules/home/home_page.dart';
import 'package:speech_app/app/modules/movimientos/movimientos_binding.dart';
import 'package:speech_app/app/modules/movimientos/crear_ingreso.dart';
import 'package:speech_app/app/modules/movimientos/crear_egreso.dart';
import 'package:speech_app/app/modules/server/server_binding.dart';
import 'package:speech_app/app/modules/server/server_page.dart';
import 'package:speech_app/app/modules/splash/splash_binding.dart';
import 'package:speech_app/app/modules/splash/splash_page.dart';
import 'app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
        name: AppRoutes.SPLASH,
        page: () => const SplashPage(),
        binding: SplashBinding()),
    GetPage(name: AppRoutes.HOME, page: () => HomePage(), binding: null),
    GetPage(
        name: AppRoutes.MCINGRESO,
        page: () => CrearIngreso(),
        binding: MovimientosBinding()),
    GetPage(
        name: AppRoutes.MCEGRESO,
        page: () => CrearEgreso(),
        binding: MovimientosBinding()),
    GetPage(
        name: AppRoutes.SERVER,
        page: () => const ServerPage(),
        binding: ServerBinding()),
  ];
}
