import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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
          TextField(maxLength: 60),
          Text('Enter a Description'),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
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
            child: Text(
                'Save TODO',
                style: TextStyle(fontSize: 20)
            ),
          ),

        ],

      ),
    );
  }

  void _saveTodo(context){
    //do checks if a name is entered
    //save Todo into SQLite database

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
