import 'package:flutter/material.dart';
import 'package:todo/Data/todo.dart';
import 'package:todo/Database/db_controller.dart';

class EditTodo extends StatefulWidget {
  final void Function(Todo edited) onTodoEdited;
  final Todo todo;

  EditTodo({this.onTodoEdited, this.todo});

  @override
  _EditTodoState createState() => _EditTodoState(this.onTodoEdited, this.todo);
}

class _EditTodoState extends State<EditTodo> {


  final void Function(Todo edited) onTodoEdited;
  final Todo todo;
  Todo editedTodo;


  _EditTodoState(this.onTodoEdited, this.todo){
    editedTodo = this.todo.copy();
    print('edited Todo: ' + editedTodo.toString());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit this TODO'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: _createForm(),
        ));
  }

  Widget _createForm() {
    return Form(
      child: Column(
        children: <Widget>[
          Text('Edit the Name'),
          TextFormField(maxLength: 60,initialValue: todo.name, onChanged: _selectName),
          Text('Edit the Description'),
          TextFormField(
            initialValue: todo.description,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: _selectDescription,
          ),
          SizedBox(height: 10),
          Text('DueDate'),
          Row(
              children: _createDateRow(),
              mainAxisAlignment: MainAxisAlignment.center),
          Text('DueTime'),
          Row(
              children: _createTimeRow(),
              mainAxisAlignment: MainAxisAlignment.center),
          RaisedButton(
            onPressed: () {
              _editTodo(context);
              // callback to parent widget

            },
            child: Text('Save TODO', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  void _selectName(String str) {
    if (str != null && str != editedTodo.name)
      setState(() {
        editedTodo.name = str;
      });
  }

  void _selectDescription(String str) {
    if (str != null && str != editedTodo.description)
      setState(() {
        editedTodo.description = str;
      });
  }

  void _editTodo(context) {
    //do checks if a name is entered
    print(editedTodo);
    DBController.instance.editTodo(todo,editedTodo);
    Navigator.of(context).pop();
    onTodoEdited(editedTodo);
  }


  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: editedTodo.dueTime,
    );
    if (picked != null && picked != editedTodo.dueTime)
      setState(() {
        editedTodo.dueTime = picked;
      });
  }

  List<Widget> _createTimeRow() {
    return <Widget>[
      Text(editedTodo.dueTime.format(context), style: TextStyle(fontSize: 18.0)),
      IconButton(
        icon: Icon(Icons.alarm),
        onPressed: () {
          _selectTime(context);
        },
      )
    ];
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: editedTodo.dueDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != editedTodo.dueDate)
      setState(() {
        editedTodo.dueDate = picked;
      });
  }

  List<Widget> _createDateRow() {
    return <Widget>[
      Text(Todo.formatDate(editedTodo.dueDate), style: TextStyle(fontSize: 18.0)),
      IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () {
          _selectDate(context);
        },
      )
    ];
  }
}
