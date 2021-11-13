import 'package:get/instance_manager.dart';
import 'package:speech_app/app/api/movimientos_api.dart';
import 'package:speech_app/app/api/saldos_api.dart';
import 'package:speech_app/app/data/providers/server_references.dart';
import 'package:speech_app/app/modules/movimientos/movimientos_controller.dart';

class MovimientosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MovimientosController());
    Get.lazyPut(() => ServerPreferences());
    Get.lazyPut(() => MovimientosApi());
    Get.lazyPut(() => SaldosApi());
  }
}
