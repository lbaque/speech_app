import 'package:get/instance_manager.dart';
import 'package:speech_app/app/api/com_item_api.dart';
import 'package:speech_app/app/api/parametros_api.dart';
import 'package:speech_app/app/api/saldos_api.dart';
import 'package:speech_app/app/data/providers/server_references.dart';
import 'package:speech_app/app/modules/splash/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => ServerPreferences());
    Get.lazyPut(() => ParametrosApi());
    Get.lazyPut(() => ComItemApi());
    Get.lazyPut(() => SaldosApi());
  }
}
