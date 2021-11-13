import 'package:speech_app/app/data/db/dbcontext.dart';
import 'package:speech_app/app/data/models/com_item.dart';
import 'dart:async';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';

class ComItemTable {
  final Dbcontext _context = Get.find<Dbcontext>();

  final String tableTodo = "com_item";
  final String columnId = 'id';
  final String columnIdServices = 'idservices';
  final String columnTipo = 'tipo';
  final String columnNombre = 'nombre';

  Future<com_item> insert(com_item model) async {
    final db = await _context.database;
    model.id = await db.insert(tableTodo, model.toMap());
    return model;
  }

  Future<List<com_item>> getAll() async {
    final db = await _context.database;
    List<Map<String, Object>> result = await db.query(tableTodo);
    if (result.isNotEmpty) {
      return result.map((x) => com_item.fromMap(x)).toList();
    } else {
      return null;
    }
  }

  Future<com_item> get(int id) async {
    final db = await _context.database;
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnIdServices, columnTipo, columnNombre],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return com_item.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(com_item model) async {
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
