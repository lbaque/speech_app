import 'package:flutter/material.dart';
import 'package:speech_app/app/api/movimientos_api.dart';
import 'package:speech_app/app/api/saldos_api.dart';
import 'package:speech_app/app/data/db/movimientos_detalles_table.dart';
import 'package:speech_app/app/data/db/saldos_table.dart';
import 'package:speech_app/app/data/models/movimientos_detalle.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:speech_app/app/data/models/response_message.dart';
import 'package:speech_app/app/data/providers/server_references.dart';
import 'package:speech_app/app/utils/dialogs.dart';
import 'package:speech_app/app/data/models/saldos.dart';

class MovimientosController extends GetxController {
  ServerPreferences _serverPreferences = Get.find<ServerPreferences>();
  MovimientosApi _api = Get.find<MovimientosApi>();
  SaldosApi apiSaldos = Get.find<SaldosApi>();
  SaldosTable _dbSaldos = SaldosTable();
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  @override
  void onReady() {
    super.onReady();

    this.cargarDetalle(Get.parameters['tipo']);
  }

  Future<void> _init() async {
    await _serverPreferences
        .init()
        .then((value) => {_serverPreferences = value});
  }

  MovimientosDetallesTable db = MovimientosDetallesTable();

  List<movimientos_detalles> _detalles = [];
  List<movimientos_detalles> get data => _detalles;

  Future<void> onSubmit(movimientos_detalles model) async {
    var Exist = await db.rawquery(
        "select * from movimientos_detalles where codigo = " +
            model.codigo +
            " and guia = " +
            model.guia);
    if (Exist == null) {
      await db.insert(model);
    }
  }

  Future<void> sincronizar(String tipo) async {
    await Future.delayed(Duration(seconds: 2));

    _api.ip = _serverPreferences.ip;
    _api.port = _serverPreferences.port;
    _api.url = _serverPreferences.url;

    var data = await db.rawquery("select * from [" +
        db.tableTodo +
        "] where tipo = '${tipo}' and  enviado = ${0}");

    if (data != null) {
      var response = await _api.create(data);
      var obj = response_message.fromMap(response.data);
      if (obj.Type == "SUCCESS") {
        await db.rawUpdate("update [" +
            db.tableTodo +
            "] set enviado = ${1} where tipo = '${tipo}' and enviado = ${0} ");
      }

      ScaffoldMessenger.of(Get.context).showSnackBar(
        SnackBar(content: Text(obj.Message)),
      );
    } else {
      ScaffoldMessenger.of(Get.context).showSnackBar(
        SnackBar(content: Text("No contiene registros")),
      );
    }
  }

  Future<void> cargarDetalle(String tipo) async {
    await db
        .rawquery("select * from [" + db.tableTodo + "] where tipo = '${tipo}'")
        .then((value) {
      if (value != null) {
        _detalles = value.toList();
      } else {
        _detalles = [];
      }
      update(['movimientos_page']);
    });
  }

  Future<void> cancelarItem(int x) async {
    var item = _detalles[x];
    await db.delete(item.id).then((value) {
      _detalles.remove(item);
      _detalles = _detalles.toList();
      update(['movimientos_page']);
    });
  }

  Future<void> CrearNuevo(String tipo) async {
    await db.deleteRawQuery(
        "Delete from [" + db.tableTodo + "] where tipo = '${tipo}'");
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
}
