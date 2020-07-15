import 'package:todo/Data/model.dart';
import 'package:todo/Data/todo.dart';
import 'package:todo/main.dart';
import 'package:flutter/material.dart';
import 'package:todo/Data/todo_list.dart';

void createTestList() {
  Model model = MyApp.model;
  if(model.todoLists.any((list) => list.name == 'Christmas Presents')) return;

  TodoList list1 = TodoList(
    color: Colors.blue,
    name: 'Christmas Presents',
    description: 'Get presents for the whole family',
  );

  model.add(list1);
  list1.add(Todo(
    name: 'Vase for mom',
    description: 'Get the blue vase from Mueller that she wanted',
    deadline: DateTime(2020, 12, 23, 18),
  ));
  list1.add(Todo(
      name: 'Shaving cream for dad', deadline: DateTime(2020, 12, 23, 18)));



  TodoList list2 = TodoList(
      color: Colors.green,
      name: 'Christmas Preparations',
      description: 'Things to prepare for Christmas');

  model.add(list2);
  list2.add(
      Todo(name: 'Get a Christmas Tree', deadline: DateTime(2020, 12, 20)));
  list2.add(Todo(name: 'Decorate the Tree', deadline: DateTime(2020, 12, 23)));
  list2.add(
      Todo(name: 'Get the groceries', deadline: DateTime(2020, 12, 23, 12)));



  TodoList list3 = TodoList(
    color: Colors.red,
    name: 'Chores',
  );

  model.add(list3);

  list3.add(Todo(
      name: 'Walk the Neighbours Dog',
      description: 'Remember to pick up the poop',
      deadline: DateTime(2020, 8, 12)));



  for(int i = 0;i<10;i++){
    TodoList testlist = TodoList(
      color: Colors.orange,
      name: 'TestList' + i.toString(),
      description: 'TestList TestDescription',
    );

    model.add(testlist);
    testlist.add(Todo(name: 'TestTodo', deadline: DateTime(2020, 12, 31, 24)));

  }
}
