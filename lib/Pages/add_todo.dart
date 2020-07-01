import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/Data/todo.dart';
import 'package:todo/Database/db_controller.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedName = "";
  String selectedDescription = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create a new TODO'),
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
          Text('Enter a Name'),
          TextField(maxLength: 60, onChanged: _selectName),
          Text('Enter a Description'),
          TextField(
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
              _saveTodo(context);
            },
            child: Text('Save TODO', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  void _selectName(String str) {
    if (str != null && str != selectedName)
      setState(() {
        selectedName = str;
      });
  }

  void _selectDescription(String str) {
    if (str != null && str != selectedDescription)
      setState(() {
        selectedDescription = str;
      });
  }

  void _saveTodo(context) {
    //do checks if a name is entered
    Todo toSave = _createTodo();
    print(toSave);
    DBController.instance.insertTodo(toSave);
    //to pop todo adder from Navigator
    Navigator.of(context).pop();

    //update state of Todolist


  }

  Todo _createTodo() {
    Todo todo = Todo(selectedName);
    todo.description = selectedDescription;
    todo.dueDate = selectedDate;
    todo.dueTime= selectedTime;
    return todo;
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  List<Widget> _createTimeRow() {
    return <Widget>[
      Text(selectedTime.hour.toString() + ':' + selectedTime.minute.toString(),
          style: TextStyle(fontSize: 18.0)),
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
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  List<Widget> _createDateRow() {
    return <Widget>[
      Text(
          selectedDate.day.toString() +
              '.' +
              selectedDate.month.toString() +
              '.' +
              selectedDate.year.toString(),
          style: TextStyle(fontSize: 18.0)),
      IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () {
          _selectDate(context);
        },
      )
    ];
  }
}
