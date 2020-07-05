import 'package:flutter/material.dart';
import 'package:todo/Database/db_controller.dart';
import 'package:todo/Pages/inspect_todo.dart';
import '../Data/todo.dart';
import 'add_todo.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _biggerFont = TextStyle(fontSize: 18.0);

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
                  builder: (context) =>
                      AddTodo(onTodoAdded: () => setState(() {}))),
            );
          },
          icon: Icon(Icons.add),
        )
      ]),
      body: FutureBuilder<List<Todo>>(
        future: DBController.instance.queryTodos(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData) {
            return _buildTodos(snapshot.data);
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTodos(List<Todo> list) {
    list.sort((a, b) {
      return a.dueDate.compareTo(b.dueDate);
    });
    final tiles = list.map(
      (Todo todo) {
        return Ink(
            color: todo.color,
            child: ListTile(
                title: Text(
                  todo.name + '  ' + Todo.formatDate(todo.dueDate),
                  style: _biggerFont,
                ),
                onTap: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (context) =>
                                TodoDetail(() => setState(() {}), todo)),
                      ),
                    },
                onLongPress: () => _removeTodo(todo)));
      },
    );

    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return ListView(children: divided);
  }

  //TODO hold an intern list of todos to work with and do database queries in parallel
  void _removeTodo(Todo todo){
    DBController.instance.delete(todo.id);
    setState(() {});
  }
}
