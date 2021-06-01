import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class DatabaseHelper{

  Future<Database> database() async{
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version){
        return db.execute(
          "Create TABLE tasks(id INTEGER PRIMARY KEY, title NEXT, description TEXT)",
        );
      },
      version: 2,
    );
  }

  Future<void> insertTask(Todo todo) async{
    Database _db = await database();
    await _db.insert('tasks',todo.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Todo>> getTasks() async{
    Database _db = await database();
    List<Map<String,dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length,(index){
      return Todo(id:taskMap[index]['id'], items: taskMap[index]['items'], description: taskMap[index]['description']);
    });
  }

}