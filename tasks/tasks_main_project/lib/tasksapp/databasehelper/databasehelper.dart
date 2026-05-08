import 'package:sqflite/sqflite.dart';
class DatabaseHelper {
  late Database database;
  createTable ()async{
    database = await openDatabase("tasks.db", version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
        });
  }
}