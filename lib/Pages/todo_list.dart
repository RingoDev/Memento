import 'package:flutter/material.dart';
import 'package:todo/Pages/inspect_todo.dart';
import 'package:todo/main.dart';
import '../Data/todo.dart';
import 'edit_todo.dart';

class TodoList extends StatefulWidget {
  TodoList();

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _biggerFont = TextStyle(fontSize: 18.0);

  _TodoListState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('TodoList'), actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (context) => EditTodo(
                        false,
                        (Todo added) =>
                            {setState(() {}), pushDetailPage(added)})),
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
        body: _buildTodos());
  }

  void pushDetailPage(Todo toInspect) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) => TodoDetail(() => setState(() {}), toInspect)),
    );
  }

  Widget _buildTodos() {
    final tiles = MyApp.model.todoList.map(
      (Todo todo) {
        return Ink(
            color: todo.color,
            child: ListTile(
                title: Text(
                  todo.name + '  ' + Todo.formatDate(todo.deadline),
                  style: _biggerFont,
                ),
                onTap: () => {pushDetailPage(todo)},
                onLongPress: () =>
                    {MyApp.model.remove(todo), setState(() {})}));
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return ListView(children: divided);
  }
}
