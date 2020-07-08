import 'package:flutter/material.dart';
import 'package:todo/Data/todo.dart';
import 'package:todo/Database/db_controller.dart';

/// holds Data and Settings of this App Instance
class Model {
  Map<int, Todo> map;
  Color color = Color(0xffffffff);

  /// the TodoList sorted by dueDate
  List<Todo> get todoList {
    List<Todo> list = map.values.toList();
    list.sort((a, b) {
      return a.dueDate.compareTo(b.dueDate);
    });
    return list;
  }

  Model(this.map, {this.color});

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

  /// to make sure DB and model are always at the same state only use these access methods.

  void add(Todo todo) {
    /// add to model
    map.putIfAbsent(todo.id, () => todo);

    /// add to DB
    DBController.instance.insertTodo(todo);
  }

  void remove(Todo todo) {
    /// remove from model
    map.remove(todo.id);

    /// remove from DB
    DBController.instance.delete(todo.id);
  }

  void edit(Todo old, Todo edited) {
    /// editing in model
    map.remove(old.id);
    map.putIfAbsent(edited.id, () => edited);

    /// editing in DB
    DBController.instance.delete(old.id);
    edited.id = old.id;
    DBController.instance.insertTodo(edited);
  }
}
