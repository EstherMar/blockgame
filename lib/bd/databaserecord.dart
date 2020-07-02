import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:tetris/bd/classrecord.dart';

class RecordDatabaseProvider {
  RecordDatabaseProvider._();

  static final RecordDatabaseProvider db = RecordDatabaseProvider._( );
  Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "recordtetris.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE recordtetris ("
              "id INTEGER PRIMARY KEY,"
              "nombre TEXT,"
              "puntos INTEGER,"
              "nivel INTEGER"")");
        });
  }

  Future<List<classrecord>> getAllRecords() async {
    final db = await database;
    var response = await db.query( "recordtetris" );
    List<classrecord> list = response.map( (c) => classrecord.fromMap( c ) )
        .toList( );
    return list;
  }

  addRecordsToDatabase(classrecord _classrecord) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM recordtetris");
    int id = table.first["id"];
    _classrecord.id = id;
    var raw = await db.insert( "recordtetris",
      _classrecord.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,);
    return raw;
  }

  updateRecord(classrecord _classrecord) async {
    final db = await database;
    var response = await db.update("recordtetris", _classrecord.toMap(),
        where: "id = ?", whereArgs: [_classrecord.id]);
    return response;
  }
}