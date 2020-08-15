import 'package:flutter/material.dart';
import 'package:memento/Data/todo_list.dart';
import 'package:memento/Database/db_controller.dart';
import 'package:memento/main.dart';

class Todo {
  Color color;
  int id;
  String name;
  String description;
  DateTime madeDate;
  TimeOfDay madeTime;
  DateTime deadline;
  bool isDone;
  int _listID;

  Todo(
      {Color color,
      this.id = -1,
      this.name = "",
      this.description = "",
      this.isDone = false,
      int listID,
      DateTime madeDate,
      TimeOfDay madeTime,
      DateTime deadline})
      : this.color = color ?? Color(0xffffffff),
        this.madeDate = madeDate ?? DateTime.now(),
        this.madeTime = madeTime ?? TimeOfDay.now(),
        this.deadline = deadline ?? DateTime.now(),
        this._listID = listID ?? null;

  void setTime(TimeOfDay time) {
    this.deadline = DateTime(
        deadline.year, deadline.month, deadline.day, time.hour, time.minute);
  }

  /// returns the ID of the List this To\do is associated with in the model;
  int get listID {
    if (this._listID == null)
      return MyApp.model.getList(this).id;
    else
      return this._listID;
  }

  set listID(int id) {
    this._listID = id;
  }

  TodoList get todoList {
    return MyApp.model.map[this.listID];
  }

  void setDate(DateTime date) {
    this.deadline = DateTime(date.year, date.month, date.day,
        this.deadline.hour, this.deadline.minute);
  }

  @override
  String toString() {
    return '\nListID: ' +
        this.listID.toString() +
        '\nid: ' +
        id.toString() +
        '\nname: ' +
        name +
        '\ndescription: ' +
        description +
        '\nColor: ' +
        color.toString() +
        '\nDeadline: ' +
        deadline.toIso8601String() +
        '\nDone: ' +
        isDone.toString();
  }

  /// formats a DateTime object to a String such as dd.mm.yyyy
  static String formatDate(DateTime date) {
    return date.day.toString() +
        '.' +
        date.month.toString() +
        '.' +
        date.year.toString();
  }

  set done(bool done) {
    this.isDone = done;
    DBController.instance.toggleTodoState(this.id, done);
  }

  Todo copy() {
    return Todo(
        id: this.id,
        name: this.name,
        description: this.description,
        deadline: this.deadline,
        color: this.color,
        isDone: this.isDone);
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

  Map toJson() {
    Map result = {
      'id': this.id,
      'description': this.description,
      'color': Todo.toARGBString(this.color),
      'deadline': this.deadline.toIso8601String(),
      'isDone': this.isDone
    };
    return result;
  }

  factory Todo.fromJson(json) {
    Todo result = Todo(
        id: json['id'],
        color: Todo.fromARGBString(json['color'] as String),
        description: json['description'] as String,
    deadline: DateTime.parse(json['deadline'] as String),
    isDone: json['isDone'] as bool);
    return result;
  }
}
