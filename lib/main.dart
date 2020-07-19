import 'package:flutter/material.dart';
import 'package:todo/Pages/main_list.dart';
import 'package:todo/Test/testlist.dart';

import 'Data/model.dart';

import 'Data/todo_list.dart';
import 'Database/db_controller.dart';

void main() {
  runApp(MyApp(
    test: true,
  ));
}

class MyApp extends StatefulWidget {
  final bool test;
  static Model model;

  MyApp({this.test = false});

  @override
  State<StatefulWidget> createState() => _MyAppState(test: this.test);
}

class _MyAppState extends State<MyApp> {
  bool test;
  int buildCounter;

  Future<Map<int, TodoList>> dataFuture;

  _MyAppState({this.test});

  @override
  void initState() {
    super.initState();
    buildCounter = 0;
    dataFuture = DBController.instance.queryAll();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOs',
      home: FutureBuilder<Map<int, TodoList>>(
        future: dataFuture,
        builder:
            (BuildContext context, AsyncSnapshot<Map<int, TodoList>> snapshot) {
          if (snapshot.hasData) {
            if(buildCounter == 0){
              MyApp.model = Model(snapshot.data);
              if (test) createTestList();
            }
            buildCounter++;
            return MainPage();
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
      theme: ThemeData.light(),
    );
  }
}
