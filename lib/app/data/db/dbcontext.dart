import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class Dbcontext {
  static Database _database;

  static final Dbcontext db = Dbcontext._();

  Dbcontext._();

  factory Dbcontext() => db;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'INSInventario.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE config_parametro(id INTEGER PRIMARY KEY AUTOINCREMENT,idservices INTEGER, tipo TEXT,codigo TEXT,valor TEXT)");
    await db.execute(
        "CREATE TABLE com_item(id INTEGER PRIMARY KEY AUTOINCREMENT,idservices INTEGER, tipo TEXT,codigo TEXT,nombre TEXT)");
    await db.execute(
        "CREATE TABLE movimientos_detalles (id INTEGER PRIMARY KEY AUTOINCREMENT,guia TEXT, codigo TEXT,cantidad REAL,lote TEXT,carga_id INTEGER, bodega_id INTEGER, enviado INTEGER, bodega TEXT, carga TEXT, producto TEXT, tipo TEXT, entrada_id INTEGER )");
    await db.execute(
        "CREATE TABLE saldos (id INTEGER PRIMARY KEY AUTOINCREMENT, codigo TEXT,cantidad REAL,lote TEXT,carga_id INTEGER, bodega_id INTEGER, bodega TEXT, carga TEXT, producto TEXT, entrada_id INTEGER, guia TEXT )");
  }
}
