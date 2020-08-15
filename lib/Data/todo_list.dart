import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:memento/Data/todo.dart';
import 'package:memento/Database/db_controller.dart';
import 'package:memento/main.dart';

class TodoList {
  Map<int, Todo> map;
  String name;
  String description;
  Color color;
  int id;
  bool detailed;

  TodoList({Map map,
    Color color,
    int id,
    this.name = "",
    this.description = "",
    this.detailed = false}) {
    this.color = color ?? Color(4278190080 + Random().nextInt(16777215));
    this.map = map ?? Map();
    this.id = id ?? MyApp.model.nextListID;
  }

  TodoList copy() {
    return TodoList(
        map: this.map,
        id: this.id,
        name: this.name,
        description: this.description,
        color: this.color);
  }

  int get nextID {
    int i = id * 1000 + 1;
    while (true) {
      if (!map.containsKey(i))
        return i;
      else
        i++;
    }
  }

  List<Todo> get openTodos {
    List<Todo> list = List();
    for (Todo todo in this.todos) {
      if (!todo.isDone) list.add(todo);
    }
    return list;
  }

  bool get hasDeadline {
    if (this.deadline == DateTime(3000))
      return false;
    else
      return true;
  }

  @override
  String toString() {
    String str = '\nPRINTING TODOLIST' +
        '\nid: ' +
        id.toString() +
        '\nname: ' +
        name +
        '\ndescription: ' +
        description +
        '\nColor: ' +
        color.toString() +
        '\nDeadline: ' +
        deadline.toIso8601String();
    map.forEach((key, value) {
      str += value.toString();
    });
    return str;
  }

  /// the TodoList sorted by dueDate
  List<Todo> get todos {
    List<Todo> list = map.values.toList();
    list.sort((a, b) {
      return a.deadline.compareTo(b.deadline);
    });
    return list;
  }

  bool get allDone {
    for (Todo todo in map.values) {
      if (!todo.isDone) return false;
    }
    return true;
  }

  DateTime get deadline {
    DateTime result = DateTime(3000);
    for (Todo todo in openTodos) {
      if (todo.deadline.isBefore(result)) {
        result = todo.deadline;
      }
    }
    return result;
  }

  /// adds To\do only to the TodoList
  void onlyAdd(Todo todo) {
    // to\do ids are in the form of xyyy where x is the list id and yyy the to\do id in the list;
    todo.id = nextID;
    todo.listID = this.id;
    // add to todoList
    map.putIfAbsent(todo.id, () => todo);
  }

  /// adds To\do to the TodoList and to the DB
  void add(Todo todo) {
    // to\do ids are in the form of xyyy where x is the list id and yyy the to\do id in the list;
    todo.id = nextID;
    todo.listID = this.id;
    // add to todoList
    map.putIfAbsent(todo.id, () => todo);

    // update this todoList in DB
    DBController.instance.update(this.id, this);
  }

  void remove(Todo todo) {
    /// remove from TodoList
    map.remove(todo.id);

    // update this todoList in DB
    DBController.instance.update(this.id, this);
  }

  void edit(Todo old, Todo edited) {
    edited.id = old.id;
    edited.listID = this.id;

    /// editing in TodoList
    map.remove(old.id);
    map.putIfAbsent(edited.id, () => edited);

    // update this todoList in DB
    DBController.instance.update(this.id, this);
  }

  Map toJson() {
    Map result = {
      'id': this.id,
      'description': this.description,
      'color': Todo.toARGBString(this.color),
      'todos': this.map.values.toList()
    };

    return result;
  }

  factory TodoList.fromJson(json) {
    List<Todo> result = List();
    (json['todos'] as List).forEach((dynamic element) {result.add(Todo.fromJson(element));});
    Map<int,Todo> resultMap = Map.fromIterable(result,key: (t)=> t.id,value:(t)=>t);

    return TodoList(
      map: resultMap,
        color: Todo.fromARGBString(json['color'] as String),
        id: json['id'],
        description: json['description'] as String);
  }
}
