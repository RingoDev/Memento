import 'package:flutter/material.dart';

class Todo {
  Color color;
  int id;
  String name;
  String description;
  DateTime madeDate;
  TimeOfDay madeTime;
  DateTime dueDate;
  TimeOfDay dueTime;
  
  Todo(
      {Color color,
      this.id = -1,
      this.name = "",
      this.description = "",
      DateTime madeDate,
      TimeOfDay madeTime,
      DateTime dueDate,
      TimeOfDay dueTime})
      : this.color = color ?? Color(0xffffffff),
        this.madeDate = madeDate ?? DateTime.now(),
        this.madeTime = madeTime ?? TimeOfDay.now(),
        this.dueDate = dueDate ?? DateTime.now(),
        this.dueTime = dueTime ?? TimeOfDay.now();

  Todo.noID(
      this.name, this.description, this.dueDate, this.dueTime, this.color);

  Todo.complete(this.id, this.name, this.description, this.dueDate,
      this.dueTime, this.color);

  @override
  String toString() {
    return '\nid: ' +
        id.toString() +
        '\nname: ' +
        name +
        '\ndescription: ' +
        description +
        '\nColor: ' +
        color.toString() +
        '\nDueDate: ' +
        dueDate.toIso8601String() +
        '\nDueTime: ' +
        dueTime.toString();
  }

  /// formats a DateTime object to a String such as dd.mm.yyyy
  static String formatDate(DateTime date) {
    return date.day.toString() +
        '.' +
        date.month.toString() +
        '.' +
        date.year.toString();
  }

  Todo copy() {
    return Todo.complete(this.id, this.name, this.description, this.dueDate,
        this.dueTime, this.color);
  }

  /// converts a String with the Format: (255,255,255,255) to a Color Object
  static Color fromARGBString(String str) {
    str = str.substring(1, str.length - 1);
    List<String> values = str.split(',');
    return Color.fromARGB(int.parse(values[0]), int.parse(values[1]),
        int.parse(values[2]), int.parse(values[3]));
  }

  /// converts a Color to an ARGB String with the Format: (255,255,255,255)
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
