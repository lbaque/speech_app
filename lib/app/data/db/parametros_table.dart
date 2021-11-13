import 'package:speech_app/app/data/db/dbcontext.dart';
import 'package:speech_app/app/data/models/config_parametro.dart';
import 'dart:async';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';

class ParametrosTable {
  final Dbcontext _context = Get.find<Dbcontext>();

  final String tableTodo = "config_parametro";
  final String columnId = 'id';
  final String columnIdServices = 'idservices';
  final String columnTipo = 'tipo';
  final String columnvalor = 'valor';

  Future<config_parametro> insert(config_parametro model) async {
    final db = await _context.database;
    model.id = await db.insert(tableTodo, model.toMap());
    return model;
  }

  Future<List<config_parametro>> getAll() async {
    final db = await _context.database;
    List<Map<String, Object>> result = await db.query(tableTodo);
    if (result.isNotEmpty) {
      return result.map((x) => config_parametro.fromMap(x)).toList();
    } else {
      return null;
    }
  }

  Future<config_parametro> get(int id) async {
    final db = await _context.database;
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnIdServices, columnTipo, columnvalor],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return config_parametro.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(config_parametro model) async {
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
