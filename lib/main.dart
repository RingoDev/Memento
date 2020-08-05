import 'package:flutter/material.dart';
import 'package:memento/Pages/main_list.dart';
import 'package:memento/Test/testlist.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  Future<Map<int, TodoList>> dataFuture;

  _MyAppState({this.test});

  @override
  void initState() {
    super.initState();
    buildCounter = 0;
    _handleSignIn();
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

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}
