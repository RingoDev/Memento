import 'package:flutter/material.dart';
import 'package:memento/Test/testlist.dart';

import '../main.dart';

class MenuDrawer extends StatefulWidget {
  final VoidCallback setParentState;
  final VoidCallback popParent;

  MenuDrawer(this.setParentState,this.popParent);

  @override
  State<StatefulWidget> createState() => _MenuDrawerState(this.setParentState,this.popParent);
}

class _MenuDrawerState extends State<MenuDrawer> {
  VoidCallback setParentState;
  VoidCallback popParent;

  _MenuDrawerState(this.setParentState,this.popParent);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Options',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage('images/cover.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          _loginTile(context),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete all'),
            onTap: () => {
              MyApp.model.removeAll(),
              this.setParentState.call(),
              Navigator.of(context).pop()
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('add TestData'),
            onTap: () => {
             createTestList(),
              this.setParentState.call(),
              Navigator.of(context).pop()
            },
          ),
        ],
      ),
    );
  }

  Widget _loginTile(context) {
    if (!MyApp.auth.loggedIn)
      return ListTile(
        leading: Icon(Icons.verified_user),
        title: Text('Login'),
        onTap: () => {showLogin(context)},
      );
    else
      return ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Logout'),
        onTap: () => {
          MyApp.auth.logOut(),
          setState(() {}),
          Navigator.of(context).pop(),
          this.setParentState.call()
        },
      );
  }

  void showLogin(context) {
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
                                this.popParent.call(),
                                this.setParentState.call()
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
}
