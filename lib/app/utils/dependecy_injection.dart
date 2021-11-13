import 'package:get/get.dart';
import 'package:speech_app/app/data/db/dbcontext.dart';

class DependencyInjection {
  static void init() {
    Get.lazyPut(() => Dbcontext());
  }
}
