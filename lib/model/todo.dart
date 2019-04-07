import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String tableTodo = "todo";
final String columnId = "_id";
final String columnTitle = "title";
final String columnDone = "done";

class Todo {
  int id;
  String title;
  bool done;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
//   Todo({this.id, this.title, this.done});
//   Todo({String title,bool done,int id}) {
//     this.title = title;
//     this.done = done;
//     this.id = id;
//   }

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
  }

  Todo.data(this.title, this.done);
}

class TodoProvider {
  Database db;

  Future open() async {
    if (db == null) {
      db = await openDatabase("$tableTodo.db", version: 1,
          onCreate: (Database db, int version) async {
        await db.execute("""
      create table $tableTodo (
        $columnId integer primary key autoincrement,
        $columnTitle text not null,
        $columnDone integer not null
      )""");
      });
    }
  }

  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<List<Todo>> getallTodo() async {
    List<Map> maps = await db.query(
      tableTodo,
      columns: [columnId, columnDone, columnTitle],
    );
    return maps.map((r) => Todo.fromMap(r)).toList();
  }

  Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Todo>> getaDone() async {
    List<Map> maps = await db.query(
      tableTodo,
      columns: [columnId, columnDone, columnTitle],
      where: "$columnDone = 1",
    );
    return maps.map((r) => Todo.fromMap(r)).toList();
  }

  Future<List<Todo>> getnotDone() async {
    List<Map> maps = await db.query(
      tableTodo,
      columns: [columnId, columnDone, columnTitle],
      where: "$columnDone = 0",
    );
    return maps.map((r) => Todo.fromMap(r)).toList();
  }

  Future<int> del(int id) async {
    return await db.delete(tableTodo, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> delDone() async {
    return await db.delete(tableTodo, where: "$columnDone = 1");
  } // deletedone

  Future<int> delTotal() async {
    return await db.delete(tableTodo);
  }

  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
