import 'package:flutter/material.dart';
import 'package:todo/Data/todo.dart';
import 'package:todo/Data/todo_list.dart';
import 'package:todo/Database/db_controller.dart';

/// holds Data and Settings of this App Instance
class Model {
  Map<int, TodoList> map;
  Color color = Color(0xffffffff);


  /// returns a List of TodoLists sorted by Deadline
  List<TodoList> get todoLists {
    List<TodoList> list = map.values.toList();
    list.sort((a, b) {
      return a.deadline.compareTo(b.deadline);
    });
    return list;
  }

  TodoList getList(Todo todo) {
    return map[todo.listID];
  }

  Model(this.map, {this.color});

  /// returns the next free ListID in the model
  int get nextListID {
    int i = 1;
    while (true) {
      if (!map.containsKey(i))
        return i;
      else
        i++;
    }
  }

  int get nextTodoID {
    bool found = false;
    int i = 1;
    while (!found) {
      found = true;
      for (TodoList todoList in map.values.toList()) {
        if (todoList.map.containsKey(i)) {
          i++;
          found = false;
          break;
        }
      }
    }
    return i;
  }

  /// to make sure DB and model are always at the same state only use these access methods.

  void add(TodoList todoList) {
    todoList.id = nextListID;

    /// add to model
    map.putIfAbsent(todoList.id, () => todoList);

    /// add to DB
    DBController.instance.insertTodoList(todoList);
  }

  void remove(TodoList todoList) {
    /// remove from model
    map.remove(todoList.id);

    /// remove from DB
    DBController.instance.deleteFullTodoList(todoList.id);
  }

  void edit(TodoList old, TodoList edited) {
    edited.id = old.id;

    /// editing in model
    map.remove(old.id);
    map.putIfAbsent(edited.id, () => edited);

    /// editing in DB
    DBController.instance.deleteTodoList(old.id);
    DBController.instance.insertTodoList(edited);
  }

  void removeAll() {
    /// remove All from model
    map.clear();

    /// remove All from DB
    DBController.instance.deleteAll();
  }
}
