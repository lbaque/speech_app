import 'package:get/get.dart';
import 'package:speech_app/app/api/com_item_api.dart';
import 'package:speech_app/app/api/parametros_api.dart';
import 'package:speech_app/app/api/saldos_api.dart';
import 'package:speech_app/app/data/providers/server_references.dart';
import 'package:speech_app/app/modules/server/server_controller.dart';

class ServerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServerController());
    Get.lazyPut(() => ServerPreferences());
    Get.lazyPut(() => ParametrosApi());
    Get.lazyPut(() => ComItemApi());
    Get.lazyPut(() => SaldosApi());
  }
}
