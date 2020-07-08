import 'package:flutter/material.dart';
import 'package:todo/Pages/inspect_todo.dart';
import 'package:todo/main.dart';
import '../Data/todo.dart';
import 'add_todo.dart';

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
                    builder: (context) =>
                        AddTodo(onTodoAdded: (Todo added) => {
                          setState((){}),
                          pushDetailPage(added)
                        })
                ),
              );
            },
            icon: Icon(Icons.add),
          )
        ]),
        body: _buildTodos());
  }

  void pushDetailPage(Todo toInspect){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) =>
              TodoDetail(() => setState(() {}), toInspect)),
    );
  }

  Widget _buildTodos() {
    final tiles = MyApp.model.todoList.map(
      (Todo todo) {
        return Ink(
            color: todo.color,
            child: ListTile(
                title: Text(
                  todo.name + '  ' + Todo.formatDate(todo.dueDate),
                  style: _biggerFont,
                ),
                onTap: () => {
                  pushDetailPage(todo)
                    },
                onLongPress: () => {
                  MyApp.model.remove(todo),
                  setState((){})
                }));
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return ListView(children: divided);
  }


}
