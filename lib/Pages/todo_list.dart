import 'package:flutter/material.dart';
import 'package:todo/Database/db_controller.dart';
import '../Data/todo.dart';
import 'add_todo.dart';


class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> _todolist = DBController.instance.queryTodos();
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TodoList'), actions: [
        IconButton(
          onPressed: () {
          },
          icon: Icon(Icons.refresh)
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (context) => AddTodo()
              ),
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
