import 'dart:ui';

import 'package:todo/Data/todo.dart';
import 'package:todo/Database/db_controller.dart';

class TodoList {
  Map<int, Todo> map;
  String name;
  String description;
  Color color;
  int id;

  TodoList({
    Map map,
    Color color,
    this.id = -1,
    this.name = "",
    this.description = "",
  }) {
   this.color = color ?? Color(0xffffffff);
   this.map = map ?? Map();
}

  TodoList copy() {
    return TodoList(
        map: this.map,
        id: this.id,
        name: this.name,
        description: this.description,
        color: this.color);
  }

  @override
  String toString() {
    return '\nPRINTING TODOLIST' + '\nid: ' +
        id.toString() +
        '\nname: ' +
        name +
        '\ndescription: ' +
        description +
        '\nColor: ' +
        color.toString() +
        '\nDeadline: ' +
        deadline.toIso8601String();
  }

  /// the TodoList sorted by dueDate
  List<Todo> get todos {
    List<Todo> list = map.values.toList();
    list.sort((a, b) {
      return a.deadline.compareTo(b.deadline);
    });
    return list;
  }

  DateTime get deadline {
    DateTime result = DateTime(3000);
    for (Todo todo in map.values) {
      if (todo.deadline.isBefore(result)) {
        result = todo.deadline;
      }
    }
    return result;
  }

  /// returns the next free ID in the TodoList
  int get nextID {
    int i = 1;
    while (true) {
      if (!map.containsKey(i))
        return i;
      else
        i++;
    }
  }

  /// adds To\do to the TodoList and to the DB
  void add(Todo todo) {
    todo.id = nextID;
    todo.listID = this.id;

    /// add to todoList
    map.putIfAbsent(todo.id, () => todo);

    /// add to DB
    DBController.instance.insertTodo(todo);
  }

  void remove(Todo todo) {
    /// remove from TodoList
    map.remove(todo.id);

    /// remove from DB
    DBController.instance.deleteTodo(todo.id);
  }

  void edit(Todo old, Todo edited) {
    edited.id = old.id;
    edited.listID = this.id;

    /// editing in TodoList
    map.remove(old.id);
    map.putIfAbsent(edited.id, () => edited);

    /// editing in DB
    DBController.instance.deleteTodo(old.id);
    DBController.instance.insertTodo(edited);
  }

  void removeAll() {
    /// remove All from todoList
    map.clear();

    /// remove All from DB
    DBController.instance.deleteAllTodos();
  }
}