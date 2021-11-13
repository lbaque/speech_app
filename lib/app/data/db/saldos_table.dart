import 'package:speech_app/app/data/db/dbcontext.dart';
import 'dart:async';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:speech_app/app/data/models/saldos.dart';

class SaldosTable {
  final Dbcontext _context = Get.find<Dbcontext>();

  final String tableTodo = "saldos";
  final String columnId = 'id';
  final String columnCodigo = 'codigo';
  final String columnCantidad = 'cantidad';
  final String columnLote = 'lote';
  final String columnCarga = "carga_id";
  final String columnaBodega = "carga_id";
  final String columnaBodegat = "bodega";
  final String columnaCargat = "carga";
  final String columnaProducto = "producto";
  final String columnaEntrada = "entrada_id";
  final String columnaGuia = "guia";

  Future<saldos> insert(saldos model) async {
    final db = await _context.database;
    model.id = await db.insert(tableTodo, model.toMap());
    return model;
  }

  Future<int> rawUpdate(String sql) async {
    final db = await _context.database;
    return await db.rawUpdate(sql);
  }

  Future<List<saldos>> rawquery(sql) async {
    final db = await _context.database;
    List<Map<String, Object>> result = await db.rawQuery(sql);
    if (result.isNotEmpty) {
      return result.map((x) => saldos.fromMap(x)).toList();
    } else {
      return null;
    }
  }

  Future<List<saldos>> getAll() async {
    final db = await _context.database;
    List<Map<String, Object>> result = await db.query(tableTodo);
    if (result.isNotEmpty) {
      return result.map((x) => saldos.fromMap(x)).toList();
    } else {
      return null;
    }
  }

  Future<saldos> get(int id) async {
    final db = await _context.database;
    List<Map> maps = await db.query(tableTodo,
        columns: [
          columnId,
          columnId,
          columnCodigo,
          columnCantidad,
          columnLote,
          columnCarga,
          columnaBodega,
          columnaBodegat,
          columnaCargat,
          columnaProducto,
          columnaEntrada,
          columnaGuia
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return saldos.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(saldos model) async {
    final db = await _context.database;
    return await db.update(tableTodo, model.toMap(),
        where: '$columnId = ?', whereArgs: [model.id]);
  }

  Future<int> delete(int id) async {
    final db = await _context.database;
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteComplete() async {
    final db = await _context.database;
    return await db.rawDelete("Delete from [" + tableTodo + "]");
  }

  Future close() async {
    final db = await _context.database;
    db.close();
  }
}
