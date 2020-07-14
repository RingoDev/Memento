import 'package:flutter/material.dart';
import 'package:todo/Data/todo_list.dart';
import 'package:todo/Pages/edit_todolist.dart';

import 'package:todo/Pages/todo_list_view.dart';
import 'package:todo/main.dart';
import '../Data/todo.dart';

class MainPage extends StatefulWidget {
  MainPage();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _biggerFont = TextStyle(fontSize: 18.0);

  _MainPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('All TodoLists'), actions: [
          IconButton(
              onPressed: () {
                print(MyApp.model.nextTodoID);
                setState(() {});
              },
              icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (context) => EditTodoList(
                        false,
                        (TodoList added) =>
                            {setState(() {}), pushTodoList(added)})),
              );
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              MyApp.model.removeAll();
              setState(() {});
            },
            icon: Icon(Icons.delete),
          )
        ]),
        body: _buildTodoLists());
  }

  void pushTodoList(TodoList toInspect) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) => TodoListView(
              () => {
                    setState(() {}),
                  },
              toInspect)),
    );
  }

  Widget _buildTodoLists() {
    final tiles = MyApp.model.todoLists.map(
      (TodoList todoList) {
        return Ink(
            color: todoList.color,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 10) {
                  print('made a right swipe');
                } else if (details.delta.dx < -10) {
                  print('made a left swipe');
                }
              },
              child: ListTile(
                  title: Text(
                    formatTileText(todoList),
                    style: _biggerFont,
                  ),
                  onTap: () => {pushTodoList(todoList)},
                  onLongPress: () =>
                      {MyApp.model.remove(todoList), setState(() {})}),
            ));
      },
    );

    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return ListView(children: divided);
  }

  static String formatTileText(TodoList todoList) {
    String str = todoList.name;
    str += '   ';
    if (todoList.hasDeadline) str += Todo.formatDate(todoList.deadline);
    return str;
  }
}
