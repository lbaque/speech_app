import 'package:speech_app/app/data/db/dbcontext.dart';
import 'package:speech_app/app/data/models/movimientos_detalle.dart';
import 'dart:async';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';

class MovimientosDetallesTable {
  final Dbcontext _context = Get.find<Dbcontext>();

  final String tableTodo = "movimientos_detalles";
  final String columnId = 'id';
  final String columnGuia = 'guia';
  final String columnCodigo = 'codigo';
  final String columnCantidad = 'cantidad';
  final String columnLote = 'lote';
  final String columnCarga = "carga_id";
  final String columnaBodega = "carga_id";
  final String columnaEnviado = "enviado";
  final String columnaBodegat = "bodega";
  final String columnaCargat = "carga";
  final String columnaProducto = "producto";
  final String columnaTipo = "tipo";
  final String columnaEntrada = "entrada_id";

  Future<movimientos_detalles> insert(movimientos_detalles model) async {
    final db = await _context.database;
    model.id = await db.insert(tableTodo, model.toMap());
    return model;
  }

  Future<int> rawUpdate(String sql) async {
    final db = await _context.database;
    return await db.rawUpdate(sql);
  }

  Future<List<movimientos_detalles>> rawquery(sql) async {
    final db = await _context.database;
    List<Map<String, Object>> result = await db.rawQuery(sql);
    if (result.isNotEmpty) {
      return result.map((x) => movimientos_detalles.fromMap(x)).toList();
    } else {
      return null;
    }
  }

  Future<List<movimientos_detalles>> getAll() async {
    final db = await _context.database;
    List<Map<String, Object>> result = await db.query(tableTodo);
    if (result.isNotEmpty) {
      return result.map((x) => movimientos_detalles.fromMap(x)).toList();
    } else {
      return null;
    }
  }

  Future<movimientos_detalles> get(int id) async {
    final db = await _context.database;
    List<Map> maps = await db.query(tableTodo,
        columns: [
          columnId,
          columnId,
          columnGuia,
          columnCodigo,
          columnCantidad,
          columnLote,
          columnCarga,
          columnaBodega,
          columnaEnviado,
          columnaBodegat,
          columnaCargat,
          columnaProducto,
          columnaTipo,
          columnaEntrada,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return movimientos_detalles.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(movimientos_detalles model) async {
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

  Future<int> deleteRawQuery(String sql) async {
    final db = await _context.database;
    return await db.rawDelete(sql);
  }

  Future close() async {
    final db = await _context.database;
    db.close();
  }
}
