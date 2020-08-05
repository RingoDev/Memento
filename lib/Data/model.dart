import 'package:flutter/material.dart';
import 'package:memento/Data/todo.dart';
import 'package:memento/Data/todo_list.dart';
import 'package:memento/Database/db_controller.dart';

/// holds Data and Settings of this App Instance
class Model {
  // TODO keep list of available IDs
  Map<int, TodoList> map;
  Color color = Color(0xffffffff);

  //the todoList which is operated upon
  List<TodoList> todoLists;

  /// returns a List of TodoLists sorted by Deadline
  void sort() {
    List<TodoList> list = map.values.toList();
    list.sort((a, b) {
      return a.deadline.compareTo(b.deadline);
    });
    this.todoLists = list;
  }


  Model(this.map, {this.color}) {
    sort();
  }

  TodoList getList(Todo todo){
    for (TodoList todoList in map.values.toList()){
      if(todoList.map.containsKey(todo.id))return todoList;
    }
    throw Exception('TODO HAD NO LIST ASSOCIATED WITH IT');
  }

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

  int nextTodoID(int i) {
    bool found = false;
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

  // to make sure DB and model are always at the same state only use these access methods.

  /// adds a TodoList (with it's Todos) to the model and the DB
  void add(TodoList todoList) {
    todoList.id = nextListID;

    /// add to model
    map.putIfAbsent(todoList.id, () => todoList);

    /// add to DB
    DBController.instance.insert(todoList);

    sort();
  }

  /// removes a TodoList and it's Todos from the model and from the DB
  void remove(TodoList todoList) {
    // remove from model
    map.remove(todoList.id);

    // remove from DB
    DBController.instance.delete(todoList.id);

    sort();
  }

  /// edits a TodoList in the model and in the DB
  void edit(TodoList old, TodoList edited) {
    edited.id = old.id;

    // editing in model
    map.remove(old.id);
    map.putIfAbsent(edited.id, () => edited);

    // editing in DB
    DBController.instance.update(old.id, edited);

    sort();
  }

  /// removes all the TodoLists and Todos from the model and the DB
  void removeAll() {
    // remove All from model
    map.clear();

    // remove All from DB
    DBController.instance.deleteAll();

    sort();
  }
}
