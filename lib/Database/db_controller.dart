import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:todo/Data/todo.dart';
import 'package:todo/Data/todo_list.dart';

class DBController {
  static final _databaseName = "todoapp.db";
  static final todoListTable = 'todoLists';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnDescription = 'description';
  static final columnColor = 'color';

  static final todoTable = 'todos';

  static final todoColumnListId = 'list_id';
  static final todoColumnDeadline = 'deadline';
  static final todoColumnIsDone = 'done';

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
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    print('created db');
    await db.execute('''
          CREATE TABLE $todoListTable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnDescription TEXT,
            $columnColor TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $todoTable (
            $columnId INTEGER PRIMARY KEY,
            $todoColumnListId INTEGER NOT NULL,
            $columnName TEXT NOT NULL,
            $columnDescription TEXT,
            $todoColumnDeadline TEXT NOT NULL,
            $columnColor TEXT NOT NULL,
            $todoColumnIsDone INTEGER NOT NULL
          )
          ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('upgraded db');
    await db.execute('DROP TABLE IF EXISTS ' + todoListTable);
    await db.execute('DROP TABLE IF EXISTS ' + todoTable);
    await db.execute('''
          CREATE TABLE $todoListTable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnDescription TEXT,
            $columnColor TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $todoTable (
            $columnId INTEGER PRIMARY KEY,
            $todoColumnListId INTEGER NOT NULL,
            $columnName TEXT NOT NULL,
            $columnDescription TEXT,
            $todoColumnDeadline TEXT NOT NULL,
            $columnColor TEXT NOT NULL
          )
          ''');
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteTodo(int id) async {
    Database db = await instance.database;
    return await db.delete(todoTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> toggleTodoState(int id, bool done) async {
    Database db = await instance.database;
    Map<String, dynamic> map = Map();
    map.putIfAbsent(todoColumnIsDone, () => done ? 1 : 0);
    await db.update(todoTable, map, where: '$columnId = ?', whereArgs: [id]);
  }
  /// deletes only the List not the Todos in DB
  Future<int> deleteTodoList(int id) async {
    Database db = await instance.database;
    return await db
        .delete(todoListTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> deleteFullTodoList(int ListID) async {
    Database db = await instance.database;
    await db.delete(todoListTable, where: '$columnId = ?', whereArgs: [ListID]);
    await db.delete(todoTable, where: '$todoColumnListId = ?', whereArgs: [ListID]);
  }

  Future<int> deleteAllTodos() async {
    Database db = await instance.database;
    return await db.delete(todoTable);
  }

  Future<int> deleteAllTodoLists() async {
    Database db = await instance.database;
    return await db.delete(todoListTable);
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    await db.delete(todoListTable);
    return await db.delete(todoTable);
  }

  Future<int> insertTodoList(TodoList todoList) async {
    Map map = Map<String, dynamic>();
    map.putIfAbsent(columnName, () => todoList.name);
    map.putIfAbsent(columnDescription, () => todoList.description);
    map.putIfAbsent(columnColor, () => Todo.toARGBString(todoList.color));
    if (todoList.id != -1)
      map.putIfAbsent(columnId, () => todoList.id);
    else
      print('ID WAS -1 !!!');
    Database db = await instance.database;
    return await db.insert(todoListTable, map);
  }

  /// inserts a To\do into the SQLite Database
  Future<int> insertTodo(Todo todo) async {
    Map map = Map<String, dynamic>();
    map.putIfAbsent(columnName, () => todo.name);
    map.putIfAbsent(columnDescription, () => todo.description);
    map.putIfAbsent(todoColumnDeadline, () => todo.deadline.toIso8601String());
    map.putIfAbsent(columnColor, () => Todo.toARGBString(todo.color));
    map.putIfAbsent(todoColumnListId, () => todo.listID);
    map.putIfAbsent(todoColumnIsDone, () => todo.isDone ? 1 : 0);
    if (todo.id != -1)
      map.putIfAbsent(columnId, () => todo.id);
    else
      print('ID WAS -1 !!!');
    Database db = await instance.database;
    return await db.insert(todoTable, map);
  }

  /// queries the SQLite Database for all the saved Todos and returns them as a Map<ID,To\do>
  Future<Map<int, Todo>> queryTodos() async {
    Map<int, Todo> result = Map();
    Database db = await instance.database;
    List<Map<String, dynamic>> mapList = await db.query(todoTable);
    for (Map map in mapList) {
      result.putIfAbsent(map[columnId], () => mapToTodo(map));
    }
    return result;
  }

  /// queries the SQLite Database for all the saved TodoLists and returns them as a Map<ID,To\doList>
  Future<Map<int, TodoList>> queryTodoLists() async {
    Map<int, TodoList> result = Map();
    Database db = await instance.database;
    List<Map<String, dynamic>> mapList = await db.query(todoListTable);
    for (Map map in mapList) {
      result.putIfAbsent(map[columnId], () => mapToTodoList(map));
    }
    return result;
  }

  /// transforms a query ResultMap to a To\do
  static Todo mapToTodo(Map<String, dynamic> map) {
    return Todo(
        name: map[columnName],
        description: map[columnDescription],
        deadline: DateTime.parse(map[todoColumnDeadline]),
        id: map[columnId],
        listID: map[todoColumnListId],
        color: Todo.fromARGBString(map[columnColor]),
        isDone: map[todoColumnIsDone] == 1 ? true : false);
  }

  /// transforms a query ResultMap to a To\doList
  static TodoList mapToTodoList(Map<String, dynamic> map) {
    return TodoList(
        name: map[columnName],
        description: map[columnDescription],
        id: map[columnId],
        color: Todo.fromARGBString(map[columnColor]));
  }

  /// returns the filled TodoLists in a map
  Future<Map<int, TodoList>> queryAll() async {
    Map<int, TodoList> todoLists = await queryTodoLists();
    Map<int, Todo> todos = await queryTodos();
    todos.forEach((id, todo) {
      if (todoLists[todo.listID] == null) print('TODOLIST DOESNT EXIST');
      todoLists[todo.listID].map.putIfAbsent(todo.id, () => todo);
    });
    return todoLists;
  }
}
