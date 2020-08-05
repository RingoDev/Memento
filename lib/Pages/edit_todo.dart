import 'package:flutter/material.dart';
import 'package:memento/Data/todo.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:memento/Data/todo_list.dart';

class EditTodo extends StatefulWidget {
  final void Function(Todo edited) onTodoAdded;
  final bool edit;
  final Todo todo;
  final TodoList todoList;

  EditTodo(this.edit, this.onTodoAdded, this.todoList, {this.todo});

  @override
  _EditTodoState createState() =>
      _EditTodoState(this.edit, this.onTodoAdded, this.todoList,
          todo: this.todo);
}

class _EditTodoState extends State<EditTodo> {
  Todo todo;
  Todo editedTodo;
  Color _tempSelectedColor = Color(0xffffffff);
  TodoList todoList;

  final void Function(Todo edited) onTodoAdded;
  final bool edit;

  _EditTodoState(this.edit, this.onTodoAdded, this.todoList, {Todo todo}) {
    this.todo = todo ?? Todo();
    this.editedTodo = this.todo.copy();
    // if its a newly added To\do use the list color as to\do color
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: todoList.color,
        appBar: AppBar(
          title: Text(!edit ? todoList.name : 'Edit a TODO'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  _saveTodo(context);
                  // callback to parent widget to set state
                  onTodoAdded(editedTodo);
                })
          ],
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
          Text('Name'),
          TextFormField(
              maxLength: 60,
              onChanged: _selectName,
              initialValue: editedTodo.name),
          Text('Description'),
          TextFormField(
            initialValue: editedTodo.description,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: _selectDescription,
          ),
          SizedBox(height: 10),
          Column(
            children: <Widget>[
              Text('Deadline'),
              Row(children: <Widget>[
                Text(
                    Todo.formatDate(editedTodo.deadline) +
                        ' ' +
                        TimeOfDay.fromDateTime(editedTodo.deadline)
                            .format(context),
                    style: TextStyle(fontSize: 18.0))
              ], mainAxisAlignment: MainAxisAlignment.center),
              IconButton(
                icon: Icon(Icons.schedule),
                onPressed: () async {
                  await _selectDeadline(context);
                },
              ),
            ],
          ),
//            ],
//          ),
          FlatButton(
            color: editedTodo.color,
            onPressed: () => _openColorPicker(),
            child: Text('Color'),
          ),
        ],
      ),
    );
  }

  /// saves the current entered name and sets the State to display it.
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

  /// shows a pop-up to pick a date and a time
  Future<Null> _selectDeadline(BuildContext context) async {
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
    //show timepicker if datepicker wasn't cancelled
    if (picked != null) {
      final TimeOfDay timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(editedTodo.deadline),
      );
      if (timePicked != null &&
          timePicked != TimeOfDay.fromDateTime(editedTodo.deadline))
        setState(() {
          editedTodo.setTime(timePicked);
        });
    }
  }

  /// shows a pop-up to pick a color
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
