import 'package:flutter/material.dart';
import 'package:todo/Data/todo.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:todo/main.dart';

class AddTodo extends StatefulWidget {
  final void Function(Todo edited) onTodoAdded;

  AddTodo({this.onTodoAdded});

  @override
  _AddTodoState createState() => _AddTodoState(this.onTodoAdded);
}

class _AddTodoState extends State<AddTodo> {

  Todo todo = Todo();
  Color _tempSelectedColor = Color(0xffffffff);

  final void Function(Todo edited) onTodoAdded;


  _AddTodoState(this.onTodoAdded);

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
          Text('Color'),
          FlatButton(
            color: todo.color,
            onPressed: () => _openColorPicker(), child: null,
          ),

          RaisedButton(
            onPressed: () {
              _saveTodo(context);
              // callback to parent widget to set state
              onTodoAdded(todo);
            },
            child: Text('Save TODO', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  void _selectName(String str) {
    if (str != null && str != todo.name)
      setState(() {
        todo.name = str;
      });
  }

  void _selectDescription(String str) {
    if (str != null && str != todo.description)
      setState(() {
        todo.description = str;
      });
  }

  void _saveTodo(context) {

    todo.id = MyApp.model.nextID;

    ///saves to model and DB
    MyApp.model.add(todo);

    /// returning to previous page
    Navigator.of(context).pop();

  }




  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: todo.dueTime,
    );
    if (picked != null && picked != todo.dueTime)
      setState(() {
        todo.dueTime = picked;
      });
  }

  List<Widget> _createTimeRow() {
    return <Widget>[
      Text(todo.dueTime.format(context), style: TextStyle(fontSize: 18.0)),
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
        initialDate: todo.dueDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != todo.dueDate)
      setState(() {
        todo.dueDate = picked;
      });
  }


  List<Widget> _createDateRow() {
    return <Widget>[
      Text(
          Todo.formatDate(todo.dueDate),
          style: TextStyle(fontSize: 18.0)),
      IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () {
          _selectDate(context);
        },
      )
    ];
  }

  void _openColorPicker(){
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text('Choose a Color'),
          content: MaterialColorPicker(
            selectedColor: _tempSelectedColor,
            onColorChange: (color) => setState(() => _tempSelectedColor = color),
          ),
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => todo.color = _tempSelectedColor);
              },
            ),
          ],
        );
      },
    );
  }
}
