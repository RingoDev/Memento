import 'package:flutter/material.dart';

class Todo {
  Color color = Color(0xffffffff);
  int id = -1;
  String name;
  String description;
  DateTime madeDate;
  TimeOfDay madeTime;
  DateTime dueDate;
  TimeOfDay dueTime;

  Todo(this.name);

  Todo.noID(this.name, this.description, this.dueDate, this.dueTime,this.color);

  Todo.complete(
      this.id, this.name, this.description, this.dueDate, this.dueTime,this.color);

  @override
  String toString() {
    return 'id: ' +
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
    return Todo.noID(this.name, this.description, this.dueDate, this.dueTime,this.color);
  }

  static Color fromARGBString(String str) {
    str = str.substring(1, str.length - 1);
    List<String> values = str.split(',');
    return Color.fromARGB(int.parse(values[0]), int.parse(values[1]),
        int.parse(values[2]), int.parse(values[3]));
  }

  static String toARGBString(Color color) {
    print('haha');
    return '(' +
        color.alpha.toString() +
        ',' +
        color.red.toString() +
        ',' +
        color.green.toString() +
        ',' +
        color.blue.toString() +
        ')';
  }
}
