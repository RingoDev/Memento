import 'package:flutter/material.dart';

import 'Data/model.dart';
import 'Data/todo.dart';
import 'Database/db_controller.dart';
import 'Pages/todo_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  static Model model;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOs',
      home: FutureBuilder<Map<int,Todo>>(
        future: DBController.instance.queryTodos(),
        builder: (BuildContext context, AsyncSnapshot<Map<int,Todo>> snapshot) {
          if (snapshot.hasData) {
            model = Model(snapshot.data);
            return TodoList();
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
      theme: ThemeData.light(),
    );
  }
}
