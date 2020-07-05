import 'package:flutter/material.dart';

class Todo {
  int id = -1;
  String name;
  String description;
  DateTime madeDate;
  TimeOfDay madeTime;
  DateTime dueDate;
  TimeOfDay dueTime;

  Todo(this.name);

  Todo.noID(this.name, this.description, this.dueDate, this.dueTime);

  Todo.complete(
      this.id, this.name, this.description, this.dueDate, this.dueTime);

  @override
  String toString() {
    return 'id' +
        id.toString() +
        '\nname: ' +
        name +
        '\ndescription: ' +
        description +
        '\nDueDate: ' +
        dueDate.toIso8601String() +
        '\nDueTime: ' +
        dueTime.toString();
  }

  static String formatDate(DateTime date) {
    return date.day.toString() +
        '.' +
        date.month.toString() +
        '.' +
        date.year.toString();
  }

  Todo copy() {
    return Todo.noID(this.name, this.description, this.dueDate, this.dueTime);
  }
}
