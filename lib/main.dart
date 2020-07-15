import 'package:flutter/material.dart';
import 'package:todo/Pages/main_list.dart';
import 'package:todo/Test/testlist.dart';

import 'Data/model.dart';

import 'Data/todo_list.dart';
import 'Database/db_controller.dart';


void main() {
  runApp(MyApp(test: true,));
}

class MyApp extends StatelessWidget {
  static Model model;
  final bool test;

  MyApp({this.test = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOs',
      home: FutureBuilder<Map<int, TodoList>>(
        future: DBController.instance.queryAll(),
        builder:
            (BuildContext context, AsyncSnapshot<Map<int, TodoList>> snapshot) {
          if (snapshot.hasData) {
            model = Model(snapshot.data);
            if(test) createTestList();
            return MainPage();
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
      theme: ThemeData.light(),
    );
  }
}
