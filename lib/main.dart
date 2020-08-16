import 'package:flutter/material.dart';
import 'package:memento/Authentication/auth.dart';
import 'package:memento/Database/cloud_storage.dart';
import 'package:memento/Pages/main_list.dart';
import 'package:memento/Test/testlist.dart';

import 'Data/model.dart';

import 'Data/todo_list.dart';
import 'Database/db_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static bool debug = false;
  static Model model;
  static AuthController auth;
  static CloudController cloud;

  MyApp();

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Map<int, TodoList>> dataFuture;

  _MyAppState();

  @override
  void initState() {
    super.initState();
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
            MyApp.model = Model(snapshot.data);
            if (MyApp.debug) createTestList();

            return MainPage();
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
      theme: ThemeData.light(),
    );
  }
}
