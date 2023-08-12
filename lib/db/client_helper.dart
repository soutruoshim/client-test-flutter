import 'package:client_test/db/client_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

List<ClientModel> _parseData(List list){
  return list.map((e) => ClientModel.fromJson(e)).toList();
}
class ClientDbHelper {
  late Database db;

  Future openDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    db = await openDatabase(path, version: databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE IF NOT EXISTS $tableName (
              $columnId INTEGER PRIMARY KEY, 
              $columnName TEXT NOT NULL, 
              $columnGender INTEGER NOT NULL
              )
          ''');
  }
  Future<ClientModel> insert(ClientModel clientModel) async {
    clientModel.id = await db.insert(tableName, clientModel.toMap);
    return clientModel;
  }
  Future<int> update(ClientModel clientModel) async {
    return await db.update(
      tableName,
      clientModel.toMap,
      where: '$columnId = ?',
      whereArgs: [clientModel.id],
    );
  }
  Future<int> delete(int id) async {
    return await db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<ClientModel>> selectAll() async {
    List list = await db.query(tableName);
    return compute(_parseData, list);
  }
  Future close() async => db.close();
  Future<List<Map<String, Object?>>> rawQuery(String sql){
    return db.rawQuery(sql);
  }
}

