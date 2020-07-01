import 'package:flutter/material.dart';

class Todo {
  String name;
  String description;
  DateTime madeDate;
  TimeOfDay madeTime;
  DateTime dueDate;
  TimeOfDay dueTime;

  Todo(this.name);

  @override
  String toString() {
    return 'name: ' +
        name +
        '\ndescription: ' +
        description +
        '\nDueDate: ' +
        dueDate.toIso8601String() +
        '\nDueTime: ' +
        dueTime.toString();
  }
}
