import 'package:flutter/material.dart';
import 'add_todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOs',
      home: TodoList(),
      theme: ThemeData.dark(),
    );
  }
}

Route _createRoute(){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddTodo(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}




class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _todolist = <Todo>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TodoList'), actions: [
        IconButton(
          onPressed: _createRoute,
          icon: Icon(Icons.add),
        )
      ]),
      body: _buildTodos(),
    );
  }




  Widget _buildAddTodo(BuildContext context){
    final tiles = _saved.map(
          (WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          onTap: (){
            _saved.remove(pair);
          },
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('New TODO'),
      ),
      body: ListView(children: divided),
    );
  }
}

class Todo{
  String name;
  DateTime made;
  DateTime dueDate;
  Todo(String name){
    this.name = name;
  }
}