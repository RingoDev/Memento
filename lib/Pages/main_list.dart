import 'package:flutter/material.dart';
import 'package:memento/Data/todo_list.dart';
import 'package:memento/Pages/edit_todolist.dart';
import 'package:memento/Pages/menu-drawer.dart';

import 'package:memento/main.dart';
import '../Data/todo.dart';
import 'edit_todo.dart';
import 'inspect_todo.dart';

class MainPage extends StatefulWidget {
  MainPage();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _biggerFont = TextStyle(fontSize: 18.0);

  _MainPageState() {
    MyApp.auth.addCallback(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuDrawer(
            () => {setState(() {})}, () => {Navigator.of(context).pop()}),
        appBar: AppBar(title: Text('All TodoLists'), actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  MyApp.model.sort();
                  _hideDetails();
                });
              },
              icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (context) => EditTodoList(
                        false, (TodoList added) => {setState(() {})})),
              );
            },
            icon: Icon(Icons.add),
          ),
          _profileButton(),
        ]),
        body: _buildTodoLists(_buildWidgetList(MyApp.model.todoLists)));
  }

  void _hideDetails() {
    for (TodoList todoList in MyApp.model.todoLists) {
      todoList.detailed = false;
    }
  }

  Widget _profileButton() {
    if (!MyApp.auth.loggedIn)
      return IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            _showLogin(context);
          });
    return IconButton(
        icon: MyApp.auth.userIcon,
        onPressed: () {
          _showLogout(context);
        });
  }

  void _showLogout(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                'Logged in as ' + MyApp.auth.userName,
                textAlign: TextAlign.center,
              ),
              content: FlatButton(
                color: ThemeData.light().accentColor,
                child: Text('Logout',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic)),
                onPressed: () =>
                    {MyApp.auth.logOut(), Navigator.of(context).pop()},
              ));
        });
  }

  void _showLogin(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Login via social account'),
            content: Container(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.input),
                    title: Text('Login with Google'),
                    onTap: () => {
                      MyApp.auth.signInWithGoogle(
                          callback: () => {
                                Navigator.of(context).pop(),
                              })
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Login with Apple'),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                  ListTile(
                    leading: Icon(Icons.verified_user),
                    title: Text('Login with Github'),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Login with Facebook'),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Login with Twitter'),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                ],
              ),
              height: 300,
              width: 300,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Exit')),
            ]);
      },
    );
  }

  Widget _buildTodoLists(List<Widget> list) {
    return ListView(children: list);
  }

  List<Widget> _buildWidgetList(List<TodoList> todoLists) {
    List<Widget> result = List();
    for (TodoList todoList in todoLists) {
      result.add(_todoListToWidget(todoList));
      result.add(Divider(
        thickness: 0,
        height: 0,
        color: Colors.grey,
      ));
      if (todoList.detailed) {
        if (todoList.description != "")
          result.add(_todoListDescrToWidget(todoList));
        for (Todo todo in todoList.todos) {
          result.add(_todoToWidget(todo));
        }
        result.add(_addTodoToWidget(todoList));
      }
    }
    return result;
  }

  Widget _addTodoToWidget(TodoList todoList) {
    return Ink(
      color: todoList.color,
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, top: 2, right: 16, bottom: 16),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
                color: Colors.white,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 10) {
                      print('made a right swipe');
                    } else if (details.delta.dx < -10) {
                      print('made a left swipe');
                    }
                  },
                  child: ListTile(title: Icon(Icons.add)),
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (context) => EditTodo(
                                false,
                                (Todo edited) => {
                                  setState(() {}),
                                  print(
                                      'added Todo (Callback in parent class)'),
                                  _pushDetailPage(edited)
                                },
                                todoList,
                              )),
                    )
                  },
                ))),
      ),
    );
  }

  Widget _todoListDescrToWidget(TodoList todoList) {
    return Ink(
        color: todoList.color,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 10) {
              print('made a right swipe');
            } else if (details.delta.dx < -10) {
              print('made a left swipe');
            }
          },
          child: ListTile(
            title: Text(
              todoList.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
            ),
            onTap: () => {_toggleDetails(todoList)},
          ),
        ));
  }

  Widget _todoListToWidget(TodoList todoList) {
    return Ink(
        color: todoList.color,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 10) {
              print('made a right swipe');
            } else if (details.delta.dx < -15) {
              print('made a left swipe');
              MyApp.model.remove(todoList);
              setState(() {});
            }
          },
          child: ListTile(
              title: Text(
                formatTileText(todoList),
                style: _biggerFont,
              ),
              trailing: _checkDoneTodos(todoList),
              onTap: () => {_toggleDetails(todoList)},
              onLongPress: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (context) => EditTodoList(
                                true,
                                (TodoList edited) => {setState(() {})},
                                todoList: todoList,
                              )),
                    )
                  }),
        ));
  }

  static Widget _checkDoneTodos(TodoList todoList) {
    int nrOpen = todoList.openTodos.length;
    switch (nrOpen) {
      case 0:
        return Icon(Icons.done_all);
      case 1:
        return Icon(Icons.filter_1);
      case 2:
        return Icon(Icons.filter_2);
      case 3:
        return Icon(Icons.filter_3);
      case 4:
        return Icon(Icons.filter_4);
      case 5:
        return Icon(Icons.filter_5);
      case 6:
        return Icon(Icons.filter_6);
      case 7:
        return Icon(Icons.filter_7);
      case 8:
        return Icon(Icons.filter_8);
      case 9:
        return Icon(Icons.filter_9);
      default:
        return Icon(Icons.filter_9_plus);
    }
  }

  Widget _todoToWidget(Todo todo) {
    return Ink(
      color: todo.todoList.color,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
                color: todo.color,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 10) {
                      print('made a right swipe');
                    } else if (details.delta.dx < -10) {
                      print('made a left swipe');
                      setState(() {
                        todo.todoList.remove(todo);
                      });
                    }
                  },
                  onLongPress: () => _pushDetailPage(todo),
                  child: CheckboxListTile(
                    title: Text(
                      todo.name,
                      style: _biggerFont,
                    ),
                    value: todo.isDone,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (bool value) {
                      setState(() {
                        todo.done = value;
                      });
                    },
                  ),
                ))),
      ),
    );
  }

  void _pushEditTodo(BuildContext context, Todo todo) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) => EditTodo(
                true,
                (Todo edited) => {
                  setState(() {}),
                  print('added Todo (Callback in parent class)'),
                  _pushDetailPage(edited)
                },
                todo.todoList,
                todo: todo,
              )),
    );
  }

  static String formatTileText(TodoList todoList) {
    String str = todoList.name;
    str += '   ';
    if (todoList.hasDeadline) str += Todo.formatDate(todoList.deadline);
    return str;
  }

  void _pushDetailPage(Todo toInspect) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) =>
              TodoDetail(() => setState(() {}), toInspect, toInspect.todoList)),
    );
  }

  void _toggleDetails(TodoList todoList) {
    todoList.detailed = !todoList.detailed;
    setState(() {});
  }
}
