import 'package:flutter/material.dart';
import 'package:todo/Database/db_controller.dart';
import '../Data/todo.dart';
import 'add_todo.dart';


class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  Future<List<Todo>> _todolist;
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    _todolist = DBController.instance.queryTodos();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TodoList'), actions: [
        IconButton(
          onPressed: () {setState(() {

          });
          },
          icon: Icon(Icons.refresh)
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (context) => AddTodo(onTodoAdded: () => setState(() {}))
              ),
            );
          },
          icon: Icon(Icons.add),
        )
      ]),
      body: FutureBuilder<List<Todo>>(
        future: DBController.instance.queryTodos(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot){
          if(snapshot.hasData){
            return _buildTodos(snapshot.data);
          }else return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildTodos(List<Todo> list) {
    final tiles = list.map(
      (Todo todo) {
        return ListTile(
          title: Text(
            todo.name,
            style: _biggerFont,
          ),
        );
      },
    );

    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return ListView(children: divided);
  }
}
