import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:memento/Data/model.dart';
import 'package:memento/Data/todo.dart';
import 'package:memento/main.dart';
import 'package:flutter/material.dart';
import 'package:memento/Data/todo_list.dart';

void createTestList() async {


  Model model = MyApp.model;
  if(model.todoLists.any((list) => list.name == 'Christmas Presents')) return;
  print('adding Testlist');



  TodoList list1 = TodoList(
    color: Colors.blue,
    name: 'Christmas Presents',
    description: 'Get presents for the whole family',
  );
  list1.onlyAdd(Todo(
    name: 'Vase for mom',
    description: 'Get the blue vase from Mueller that she wanted',
    deadline: DateTime(2020, 12, 23, 18),
  ));
  list1.onlyAdd(Todo(
     name: 'Shaving cream for dad', deadline: DateTime(2020, 12, 23, 18)));

  model.add(list1);


  TodoList list2 = TodoList(
      color: Colors.green,
      name: 'Christmas Preparations',
      description: 'Things to prepare for Christmas');


  list2.onlyAdd(
      Todo(name: 'Get a Christmas Tree', deadline: DateTime(2020, 12, 20)));
  list2.onlyAdd(Todo(name: 'Decorate the Tree', deadline: DateTime(2020, 12, 23)));
  list2.onlyAdd(
      Todo(name: 'Get the groceries', deadline: DateTime(2020, 12, 23, 12)));

  model.add(list2);



  TodoList list3 = TodoList(
    color: Colors.red,
    name: 'Chores',
  );

  list3.onlyAdd(Todo(
      name: 'Walk the Neighbours Dog',
      description: 'Remember to pick up the poop',
      deadline: DateTime(2020, 8, 12)));

  model.add(list3);

  for(int i = 0;i<10;i++){
    TodoList testlist = TodoList(
      color: Color(4278190080+Random().nextInt(16777215)),
      name: 'TestList' + i.toString(),
      description: 'TestList TestDescription',
    );
    int x= Random().nextInt(15);
    for(int j = 0;j<x;j++){
      testlist.onlyAdd(Todo(name: 'TestTodo'+j.toString(), deadline: DateTime(2021, j+x%12+1, j+x*10%29, j*2%24)));
    }
    model.add(testlist);
  }



}

