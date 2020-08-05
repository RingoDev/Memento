import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:memento/Data/todo_list.dart';
import 'package:memento/main.dart';

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

  /// if a todoList was specified, use it as template for the site.
  /// otherwise create empty TodoList
  _EditTodoListState(this.edit, this.onChange, {TodoList todoList}) {
    this.todoList = todoList ?? TodoList();
    this.editedTodoList = this.todoList.copy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(!edit
              ? (editedTodoList.name == '' ? 'Create a new Todolist' : editedTodoList.name)
              : todoList.name),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  _saveTodoList(context);
                  print(editedTodoList);
                  // callback to parent widget to set state
                  onChange(editedTodoList);
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
              initialValue: editedTodoList.name),
          Text('Description'),
          TextFormField(
            initialValue: editedTodoList.description,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: _selectDescription,
          ),
          SizedBox(height: 10),
          FlatButton(
            color: editedTodoList.color,
            onPressed: () => _openColorPicker(),
            child: Text('Color'),
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

  /// if page is in 'edit' mode To\do is edited otherwise its saved.
  /// navigates to the previous page after saving.
  void _saveTodoList(context) {
    if (edit) {
      MyApp.model.edit(todoList, editedTodoList);
    } else {
      MyApp.model.add(editedTodoList);
    }
    Navigator.of(context).pop();
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
                setState(() => editedTodoList.color = _tempSelectedColor);
              },
            ),
          ],
        );
      },
    );
  }
}
