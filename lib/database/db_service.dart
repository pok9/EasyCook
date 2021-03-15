import 'package:sqflite/sqflite.dart';
import 'package:easy_cook/database/db_connection.dart';

class DBService{
  DatabaseConnection _databaseConnection;
  String tableName = 'tokenDB';

  DBService(){
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  readData() async {
    var connection = await database;
    return await connection.query(tableName);
  }

  insertData(data) async {
    var connection = await database;
    return await connection.insert(tableName, data);
  }

  deleteAllData() async {
    var connection = await database;
    return await connection.delete(tableName);
  }
}