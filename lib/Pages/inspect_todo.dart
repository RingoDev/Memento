import 'package:flutter/material.dart';
import 'package:memento/Data/todo.dart';
import 'package:memento/Data/todo_list.dart';
import 'edit_todo.dart';

class TodoDetail extends StatefulWidget {
  final VoidCallback onTodoChanged;
  final Todo todo;
  final TodoList todoList;

  TodoDetail(this.onTodoChanged, this.todo, this.todoList);

  @override
  _TodoDetailState createState() =>
      _TodoDetailState(this.onTodoChanged, this.todo, this.todoList);
}

class _TodoDetailState extends State<TodoDetail> {
  final _biggerFont = TextStyle(fontSize: 18.0);
  Todo todo;
  final TodoList todoList;
  final VoidCallback onTodoChanged;

  _TodoDetailState(this.onTodoChanged, this.todo, this.todoList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editTodo(),
          )
        ],
      ),
      body: Center(child: _buildTodo(todo)),
      backgroundColor: todo.color,
    );
  }

  // Todo make page nicer
  /// Builds the 'Todo_Detail' page
  Widget _buildTodo(todo) {
    return Column(
      children: <Widget>[
        Text(
          todo.description,
          style: _biggerFont,
        ),
        Text(
          todo.deadline.toString(),
          style: _biggerFont,
        ),
      ],
    );
  }

  /// navigates to the 'Edit_Todo' page and passes the the current To\do on to the page.
  void _editTodo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) => EditTodo(
              true, (Todo edited) => update(edited), todoList,
              todo: todo)),
    );
  }

  /// updates the state and passes change on to parent class
  void update(Todo todo) {
    setState(() {
      this.todo = todo;
    });
    onTodoChanged();
  }
}
