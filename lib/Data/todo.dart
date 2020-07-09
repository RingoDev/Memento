import 'package:flutter/material.dart';

class Todo {
  Color color;
  int id;
  String name;
  String description;
  DateTime madeDate;
  TimeOfDay madeTime;
  DateTime deadline;

  Todo(
      {Color color,
      this.id = -1,
      this.name = "",
      this.description = "",
      DateTime madeDate,
      TimeOfDay madeTime,
      DateTime deadline})
      : this.color = color ?? Color(0xffffffff),
        this.madeDate = madeDate ?? DateTime.now(),
        this.madeTime = madeTime ?? TimeOfDay.now(),
        this.deadline = deadline ?? DateTime.now();

  void setTime(TimeOfDay time) {
    this.deadline = DateTime(
        deadline.year, deadline.month, deadline.day, time.hour, time.minute);
  }

  void setDate(DateTime date) {
    this.deadline = DateTime(date.year, date.month, date.day,
        this.deadline.hour, this.deadline.minute);
  }

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
        '\nDeadline: ' +
        deadline.toIso8601String();
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
    return Todo(
        id: this.id,
        name: this.name,
        description: this.description,
        deadline: this.deadline,
        color: this.color);
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
