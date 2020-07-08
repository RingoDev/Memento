import 'package:flutter/material.dart';
import 'package:todo/Data/todo.dart';
import 'edit_todo.dart';

class TodoDetail extends StatefulWidget {
  final VoidCallback onTodoChanged;
  final Todo todo;

  TodoDetail(this.onTodoChanged, this.todo);

  @override
  _TodoDetailState createState() =>
      _TodoDetailState(this.onTodoChanged, this.todo);
}

class _TodoDetailState extends State<TodoDetail> {
  final _biggerFont = TextStyle(fontSize: 18.0);
  Todo todo;
  final VoidCallback onTodoChanged;

  _TodoDetailState(this.onTodoChanged, this.todo);

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

  Widget _buildTodo(todo) {
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

  void _editTodo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) => EditTodo(
              onTodoEdited: (Todo edited) => setState(() {
                    todo = edited;
                    onTodoChanged();
                  }),
              todo: todo)
      ),
    );
  }
}
