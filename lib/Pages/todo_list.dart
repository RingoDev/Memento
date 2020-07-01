import 'package:flutter/material.dart';
import '../Data/todo.dart';
import 'add_todo.dart';


class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _todolist = <Todo>[];
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TodoList'), actions: [
        IconButton(
          onPressed: () {
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddTodo(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
          icon: Icon(Icons.add),
        )
      ]),
      body: _buildTodos(),
    );
  }

  Widget _buildTodos() {
    final tiles = _todolist.map(
      (Todo todo) {
        return ListTile(
          title: Text(
            todo.name,
            style: _biggerFont,
          ),
        );
      },
    );

    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return ListView(children: divided);
  }
}
