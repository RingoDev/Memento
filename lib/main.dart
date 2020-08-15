import 'package:flutter/material.dart';
import 'package:memento/Authentication/auth.dart';
import 'package:memento/Database/cloud_storage.dart';
import 'package:memento/Pages/main_list.dart';
import 'package:memento/Test/testlist.dart';

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
  static AuthController auth;
  static CloudController cloud;

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
    MyApp.auth = AuthController();
    MyApp.cloud = CloudController();
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
