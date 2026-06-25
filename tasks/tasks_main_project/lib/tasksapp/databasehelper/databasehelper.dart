
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // {"isDone": false, "taskTitle": "تغيير خلفية التطبيق للوضع الليلي", "hasReminder": false, "createdAt": "2026-05-08 10:00 AM"},

   Database? database;
  createTable () async{
    database = await openDatabase("tasks.db", version: 1,
        onCreate: (Database db, int version) async {
      print("database created");
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE do_table (id INTEGER PRIMARY KEY, task TEXT,detail TEXT, time TEXT, isDone BOOLEAN , hasReminder BOOLEAN )');
          print("created table");

        },onOpen: (db) {
          print("database open");
        },);
  }


///
///

   void fillDataDo_table({required String task,required String detail,required String time})async{
     await database?.transaction((txn)async{
       txn.rawInsert(
           "INSERT INTO do_table (task,detail,time,isDone) VALUES (?,?,?,?)",
           [task,detail,time,false]
       ).then((v){
         print("Inserted Row ${v}");
       }).catchError((e){
         print("Exception $e");
       });
     });
   }
   void updatedata({required String fn,required int sal,required int id})async{
     database?.rawUpdate(
         "UPDATE do_table SET fullname=?,salary=? where employee_id=?",
         [fn,sal,id]
     ).then((v){
       print("Update Data ! $v");
     }).catchError((e){
       print("Exception is $e");
     });
   }
   void deleteEmployee({required int id})async
   {
     database?.rawDelete(
         "DELETE FROM do_table where employee_id=?",
         [id]
     ).then((v){
       print("Deleted Row $v");
     }).catchError((e){
       print("Exception is $e");
     });
   }
   Future getEmployeeData(Database obj)async
   {
     return await obj.rawQuery("SELECT * FROM do_table");
   }
///
///

}