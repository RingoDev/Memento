import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:todo/Data/todo.dart';

class DBController {
  static final _databaseName = "todolist.db";
  static final table = 'todos';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnDescription = 'description';
  static final columnDate = 'due_date';
  static final columnTime = 'due_time';
  static final columnColor = 'color';

  // make this a singleton class
  DBController._privateConstructor();

  static final DBController instance = DBController._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), _databaseName),
        version: 3, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    print('created db');
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnDescription TEXT,
            $columnDate TEXT NOT NULL,
            $columnTime TEXT NOT NULL,
            $columnColor TEXT NOT NULL
          )
          ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('upgraded db');
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnDescription TEXT,
            $columnDate TEXT NOT NULL,
            $columnTime TEXT NOT NULL,
            $columnColor TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  /// inserts a To\do into the SQLite Database
  Future<int> insertTodo(Todo todo) async {
    Map map = Map<String, dynamic>();
    map.putIfAbsent(columnName, () => todo.name);
    map.putIfAbsent(columnDescription, () => todo.description);
    map.putIfAbsent(columnDate, () => todo.dueDate.toIso8601String());
    map.putIfAbsent(
        columnTime,
        () =>
            todo.dueTime.hour.toString() +
            ':' +
            todo.dueTime.minute.toString());
    map.putIfAbsent(columnColor, () => Todo.toARGBString(todo.color));
    if (todo.id != -1)
      map.putIfAbsent(columnId, () => todo.id);
    else
      print('ID WAS -1 !!!');
    return await insert(map);
  }

  /// queries the SQLite Database for all the saved Todos and returns them as a Map<ID,To\do>
  Future<Map<int, Todo>> queryTodos() async {
    Map<int, Todo> result = Map();
    List<Map<String, dynamic>> mapList = await queryAllRows();
    for (Map map in mapList) {
      result.putIfAbsent(map[columnId], () => mapToTodo(map));
    }
    return result;
  }

  /// transforms a query ResultMap to a To\do
  static Todo mapToTodo(Map<String, dynamic> map) {
    Todo todo = new Todo(
        name: map[columnName],
        description: map[columnDescription],
        dueTime: TimeOfDay(
            hour: int.parse(map[columnTime].split(":")[0]),
            minute: int.parse(map[columnTime].split(":")[1])),
        dueDate: DateTime.parse(map[columnDate]),
        id: map[columnId],
        color: Todo.fromARGBString(map[columnColor]));
    return todo;
  }

  /// edits a To\do by removing the To\do from the table and then adding the edited one with the old ID
  Future<int> editTodo(Todo oldTodo, Todo newTodo) {
    delete(oldTodo.id);
    newTodo.id = oldTodo.id;
    return insertTodo(newTodo);
  }
}
