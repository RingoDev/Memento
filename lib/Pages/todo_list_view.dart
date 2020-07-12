import 'package:flutter/material.dart';
import 'package:todo/Data/todo_list.dart';
import 'package:todo/Pages/inspect_todo.dart';
import 'package:todo/main.dart';
import '../Data/todo.dart';
import 'edit_todo.dart';

class TodoListView extends StatefulWidget {
  VoidCallback onChange;
  TodoList todoList;
  TodoListView(this.onChange,this.todoList);

  @override
  _TodoListViewState createState() => _TodoListViewState(this.onChange,this.todoList);
}

class _TodoListViewState extends State<TodoListView> {
  final _biggerFont = TextStyle(fontSize: 18.0);
  VoidCallback onChange;
  TodoList todoList;

  _TodoListViewState(this.onChange,this.todoList);

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
                            {setState(() {}), pushDetailPage(added)},this.todoList)),
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
          builder: (context) => TodoDetail(() => setState(() {}), toInspect,this.todoList)),
    );
  }

  Widget _buildTodos() {
    final tiles = todoList.todos.map(
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
                    {todoList.remove(todo), setState(() {})}));
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return ListView(children: divided);
  }
}
