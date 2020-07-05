import 'package:flutter/material.dart';

import 'Pages/todo_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOs',
      home: TodoList(),
      theme: ThemeData.light(),
    );
  }
}
