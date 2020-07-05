import 'package:flutter/material.dart';
import 'package:todo/Data/todo.dart';

class TodoDetail extends StatefulWidget {
  Todo todo;

  TodoDetail(this.todo);

  @override
  _TodoDetailState createState() => _TodoDetailState(this.todo);
}

class _TodoDetailState extends State<TodoDetail> {
  final _biggerFont = TextStyle(fontSize: 18.0);
  Todo todo;

  _TodoDetailState(this.todo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(todo.name),
          actions: <Widget>[IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editTodo(todo),
          )],
        ),
        body: Center(child: _createTodo(todo)));
  }

  Widget _createTodo(todo) {
    return Column(
      children: <Widget>[
        Text(
          todo.description,
          style: _biggerFont,
        ),
        Text(
          Todo.formatDate(todo.dueDate),
          style: _biggerFont,
        ),
        Text(
          todo.dueTime.format(context),
          style: _biggerFont,
        )
      ],
    );
  }

  void _editTodo(Todo todo){
    // open add_todo with data from todo
  }
}
