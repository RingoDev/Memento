import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create a new TODO'),
        ),
        body: Center(
            child: ListView(padding: EdgeInsets.all(16.0), children: [
          _createForm(),
          Row(
            children: _createDateRow(),
          )
        ])));
  }

  Widget _createForm() {
    return Form(
      child: TextField(),
    );
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
      Text(formatDate(selectedDate), style: TextStyle(fontSize: 18.0)),
      IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () {
          _selectDate(context);
        },
      )
    ];
  }
}

String formatDate(DateTime datetime) {
  return datetime.day.toString() +
      '.' +
      datetime.month.toString() +
      '.' +
      datetime.year.toString();
}
