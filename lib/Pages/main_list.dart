import 'package:flutter/material.dart';
import 'package:todo/Data/todo_list.dart';
import 'package:todo/Pages/edit_todolist.dart';

import 'package:todo/main.dart';
import '../Data/todo.dart';
import 'edit_todo.dart';
import 'inspect_todo.dart';

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
                            {setState(() {})})),
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
        body: _buildTodoLists(_buildWidgetList(MyApp.model.todoLists)));
  }


  List<Widget> _buildWidgetList(List<TodoList> todoLists) {
    List<Widget> result = List();
    for (TodoList todoList in todoLists) {
      result.add(_todoListToWidget(todoList));
      if (todoList.detailed) {
        for (Todo todo in todoList.todos) {
          result.add(_todoToWidget(todo));
        }
      }
    }
    return result;
  }

  Widget _todoListToWidget(TodoList todoList) {
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
              onTap: () => {_toggleDetails(todoList)},
              onLongPress: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (context) => EditTodoList(
                              true,
                              (TodoList edited) =>
                                  {setState(() {})},todoList: todoList,)),
                    )
                  }),
        ));
  }

  Widget _todoToWidget(Todo todo) {
    return Ink(
      color: todo.todoList.color,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
                color: todo.color,
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
                      todo.name,
                      style: _biggerFont,
                    ),
                    onTap: () => _pushDetailPage(todo),
                    onLongPress: () => _pushEditTodo(context, todo),
                  ),
                ))),
      ),
    );
  }

  void _pushEditTodo(BuildContext context, Todo todo) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) => EditTodo(
                true,
                (Todo edited) => {
                  setState(() {}),
                  print('added Todo (Callback in parent class)'),
                  _pushDetailPage(edited)
                },
                todo.todoList,
                todo: todo,
              )),
    );
  }

  Widget _buildTodoLists(List<Widget> list) {
    final divided = ListTile.divideTiles(
      context: context,
      tiles: list,
    ).toList();
    return ListView(children: divided);
  }

  static String formatTileText(TodoList todoList) {
    String str = todoList.name;
    str += '   ';
    if (todoList.hasDeadline) str += Todo.formatDate(todoList.deadline);
    return str;
  }

  void _pushDetailPage(Todo toInspect) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) =>
              TodoDetail(() => setState(() {}), toInspect, toInspect.todoList)),
    );
  }

  void _toggleDetails(TodoList todoList) {
    todoList.detailed = !todoList.detailed;
    setState(() {});
  }
}
