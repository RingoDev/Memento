import 'package:flutter/material.dart';
import 'package:todo/Data/todo.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:todo/Data/todo_list.dart';


class EditTodo extends StatefulWidget {
  final void Function(Todo edited) onTodoAdded;
  final bool edit;
  final Todo todo;
  final TodoList todoList;

  EditTodo(this.edit, this.onTodoAdded,this.todoList, {this.todo});

  @override
  _EditTodoState createState() =>
      _EditTodoState(this.edit, this.onTodoAdded,this.todoList, todo: this.todo);
}

class _EditTodoState extends State<EditTodo> {
  Todo todo;
  Todo editedTodo;
  Color _tempSelectedColor = Color(0xffffffff);
  TodoList todoList;

  final void Function(Todo edited) onTodoAdded;
  final bool edit;

  _EditTodoState(this.edit, this.onTodoAdded, this.todoList,{Todo todo}) {
    this.todo = todo ?? Todo();
    this.editedTodo = this.todo.copy();
    // if its a newly added To\do use the list color as to\do color
    if(!edit) this.editedTodo.color = this.todoList.color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(!edit ? 'Create a new TODO' : 'Edit a TODO'),
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
          TextFormField(
              maxLength: 60,
              onChanged: _selectName,
              initialValue: editedTodo.name),
          Text('Enter a Description'),
          TextFormField(
            initialValue: editedTodo.description,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: _selectDescription,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('DueDate'),
                  Row(children: <Widget>[
                    Text(Todo.formatDate(editedTodo.deadline),
                        style: TextStyle(fontSize: 18.0))
                  ], mainAxisAlignment: MainAxisAlignment.center),
                  IconButton(
                    icon: Icon(Icons.event),
                    onPressed: () {
                      _selectDate(context);
                    },
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text('DueTime'),
                  Row(children: <Widget>[
                    Text(
                        TimeOfDay.fromDateTime(editedTodo.deadline)
                            .format(context),
                        style: TextStyle(fontSize: 18.0))
                  ], mainAxisAlignment: MainAxisAlignment.center),
                  IconButton(
                    icon: Icon(Icons.schedule),
                    onPressed: () {
                      _selectTime(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          Text('Color'),
          FlatButton(
            color: editedTodo.color,
            onPressed: () => _openColorPicker(),
            child: null,
          ),
          RaisedButton(
            onPressed: () {
              _saveTodo(context);
              // callback to parent widget to set state
              onTodoAdded(editedTodo);
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

  void _saveTodo(context) {
    if (edit) {
      todoList.edit(todo, editedTodo);
    } else {
      todoList.add(editedTodo);
    }

    /// returning to previous page
    Navigator.of(context).pop();
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(editedTodo.deadline),
    );
    if (picked != null && picked != TimeOfDay.fromDateTime(editedTodo.deadline))
      setState(() {
        editedTodo.setTime(picked);
      });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: editedTodo.deadline,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != editedTodo.deadline) {
      setState(() {
        editedTodo.setDate(picked);
      });
    }
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text('Choose a Color'),
          content: MaterialColorPicker(
            selectedColor: _tempSelectedColor,
            onColorChange: (color) =>
                setState(() => _tempSelectedColor = color),
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
                setState(() => editedTodo.color = _tempSelectedColor);
              },
            ),
          ],
        );
      },
    );
  }
}
