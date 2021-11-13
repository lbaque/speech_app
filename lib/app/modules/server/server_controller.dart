import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:speech_app/app/api/com_item_api.dart';
import 'package:speech_app/app/api/parametros_api.dart';
import 'package:speech_app/app/api/saldos_api.dart';
import 'package:speech_app/app/data/db/saldos_table.dart';
import 'package:speech_app/app/data/db/com_item_table.dart';
import 'package:speech_app/app/data/db/parametros_table.dart';
import 'package:speech_app/app/data/providers/server_references.dart';
import 'package:speech_app/app/routes/app_routes.dart';
import 'package:speech_app/app/utils/dialogs.dart';
import 'package:speech_app/app/data/models/com_item.dart';
import 'package:speech_app/app/data/models/config_parametro.dart';
import 'package:speech_app/app/data/models/saldos.dart';

class ServerController extends GetxController {
  ServerPreferences _serverPreferences = Get.find<ServerPreferences>();

  ServerPreferences get data => _serverPreferences;

  ParametrosApi apiParametros = Get.find<ParametrosApi>();
  ComItemApi apiComItems = Get.find<ComItemApi>();
  SaldosApi apiSaldos = Get.find<SaldosApi>();

  ParametrosTable _dbParametros = ParametrosTable();
  ComItemTable _dbComItems = ComItemTable();
  SaldosTable _dbSaldos = SaldosTable();

  @override
  void onReady() {
    _init();
    super.onReady();
  }

  Future<void> _init() async {
    await _serverPreferences
        .init()
        .then((value) => {_serverPreferences = value});
  }

//Text field state
  String _url = "";
  String _ip = "";
  String _port = "";

  void onURLChanged(String t) {
    _url = t;
  }

  void onPORTChanged(String t) {
    _port = t;
  }

  void onIPChanged(String t) {
    _ip = t;
  }

  //REGISTER
  Future<void> onCreate() async {
    _serverPreferences.ip = _ip;
    _serverPreferences.url = _url;
    _serverPreferences.port = _port;
    _serverPreferences.commit().then((x) {
      messageDialog("Alerta!", "Datos Guardados.");
    });
  }

  Future<void> onSincronizar() async {
    await _dbParametros.getAll().whenComplete(() {
      cargarParametros().whenComplete(() {
        cargarItems().whenComplete(() {
          cargarSaldo().whenComplete(() {
            Get.offNamed(AppRoutes.HOME);
          });
        });
      });
    });
  }

  Future<void> cargarParametros() async {
    ProgressDialog.show(Get.context, "Sincronizando Parametros");
    await Future.delayed(Duration(seconds: 2));

    apiParametros.ip = _serverPreferences.ip;
    apiParametros.port = _serverPreferences.port;
    apiParametros.url = _serverPreferences.url;
    var response = await apiParametros.getParametros();
    if (response.data != null) {
      var query =
          response.data.map((x) => config_parametro.fromMap(x)).toList();

      await _dbParametros.deleteComplete().whenComplete(() {
        for (var item in query) {
          _dbParametros.insert(item);
        }
      });
    }

    ProgressDialog.dissmiss(Get.context);
  }

  Future<void> cargarItems() async {
    ProgressDialog.show(Get.context, "Sincronizando Items");
    await Future.delayed(Duration(seconds: 2));

    apiComItems.ip = _serverPreferences.ip;
    apiComItems.port = _serverPreferences.port;
    apiComItems.url = _serverPreferences.url;
    var response = await apiComItems.getItems();
    if (response.data != null) {
      var query = response.data.map((x) => com_item.fromMap(x)).toList();

      await _dbComItems.deleteComplete().whenComplete(() {
        for (var item in query) {
          _dbComItems.insert(item);
        }
      });
    }

    ProgressDialog.dissmiss(Get.context);
  }

  Future<void> cargarSaldo() async {
    ProgressDialog.show(Get.context, "Sincronizando Saldo");
    await Future.delayed(Duration(seconds: 2));

    apiSaldos.ip = _serverPreferences.ip;
    apiSaldos.port = _serverPreferences.port;
    apiSaldos.url = _serverPreferences.url;
    var response = await apiSaldos.getSaldos();
    if (response.data != null) {
      var query = response.data.map((x) => saldos.fromMap(x)).toList();

      await _dbSaldos.deleteComplete().whenComplete(() {
        for (var item in query) {
          _dbSaldos.insert(item);
        }
      });
    }

    ProgressDialog.dissmiss(Get.context);
  }

  void messageDialog(String title, String message) {
    Get.dialog(AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FlatButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(AppRoutes.SPLASH);
            },
            child: Text("OK"))
      ],
    ));
  }
}
