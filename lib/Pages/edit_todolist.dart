import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:todo/Data/todo_list.dart';
import 'package:todo/main.dart';

class EditTodoList extends StatefulWidget {
  final void Function(TodoList edited) onChange;
  final bool edit;
  final TodoList todoList;

  EditTodoList(this.edit, this.onChange, {this.todoList});

  @override
  _EditTodoListState createState() =>
      _EditTodoListState(this.edit, this.onChange, todoList: this.todoList);
}

class _EditTodoListState extends State<EditTodoList> {
  TodoList todoList;
  TodoList editedTodoList;
  Color _tempSelectedColor = Color(0xffffffff);

  final void Function(TodoList edited) onChange;
  final bool edit;

  _EditTodoListState(this.edit, this.onChange, {TodoList todoList}) {
    this.todoList = todoList ?? TodoList();
    this.editedTodoList = this.todoList.copy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(!edit ? 'Create a new TODOlist' : todoList.name),
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
              initialValue: editedTodoList.name),
          Text('Description'),
          TextFormField(
            initialValue: editedTodoList.description,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: _selectDescription,
          ),
          SizedBox(height: 10),
          Text('Color'),
          FlatButton(
            color: editedTodoList.color,
            onPressed: () => _openColorPicker(),
            child: null,
          ),
          RaisedButton(
            onPressed: () {
              _saveTodoList(context);
              print(editedTodoList);
              // callback to parent widget to set state
              onChange(editedTodoList);
            },
            child: Text('Save', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  void _selectName(String str) {
    if (str != null && str != editedTodoList.name)
      setState(() {
        editedTodoList.name = str;
      });
  }

  void _selectDescription(String str) {
    if (str != null && str != editedTodoList.description)
      setState(() {
        editedTodoList.description = str;
      });
  }

  void _saveTodoList(context) {
    if (edit) {
      MyApp.model.edit(todoList, editedTodoList);
    } else {
      MyApp.model.add(editedTodoList);
    }

    /// returning to previous page
    Navigator.of(context).pop();
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
                setState(() => editedTodoList.color = _tempSelectedColor);
              },
            ),
          ],
        );
      },
    );
  }
}
