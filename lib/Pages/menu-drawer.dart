import 'package:flutter/material.dart';
import 'package:memento/Test/testlist.dart';

import '../main.dart';

class MenuDrawer extends StatefulWidget {
  final VoidCallback setParentState;
  final VoidCallback popParent;
  final void Function(Text snackText) showSnackBar;

  MenuDrawer(this.setParentState, this.popParent, this.showSnackBar);

  @override
  State<StatefulWidget> createState() =>
      _MenuDrawerState(this.setParentState, this.popParent, this.showSnackBar);
}

class _MenuDrawerState extends State<MenuDrawer> {
  VoidCallback setParentState;
  VoidCallback popParent;
  Function(Text snackText) showSnackBar;

  _MenuDrawerState(this.setParentState, this.popParent, this.showSnackBar);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: _createDrawerItems()),
    );
  }

  List<Widget> _createDrawerItems() {
    List<Widget> list = List();
    list.add(DrawerHeader(
      child: Text(
        'memento',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
      decoration: BoxDecoration(
          color: Colors.green,
          image: DecorationImage(
              fit: BoxFit.fill, image: AssetImage('images/cover.jpg'))),
    ));
    if (MyApp.debug)
      list.add(ListTile(
        leading: Icon(Icons.input),
        title: Text('Welcome'),
        onTap: () => {},
      ));
    if (MyApp.debug)
      list.add(ListTile(
        leading: Icon(Icons.settings),
        title: Text('Settings'),
        onTap: () => {Navigator.of(context).pop()},
      ));
    list.add(_loginTile(context));
    if (MyApp.debug)
      list.add(ListTile(
        leading: Icon(Icons.delete),
        title: Text('Delete all'),
        onTap: () => {
          MyApp.model.removeAll(),
          this.setParentState.call(),
          Navigator.of(context).pop()
        },
      ));
    if (MyApp.debug)
      list.add(ListTile(
        leading: Icon(Icons.add),
        title: Text('add TestData'),
        onTap: () => {
          createTestList(),
          this.setParentState.call(),
          Navigator.of(context).pop()
        },
      ));
    list.add(ListTile(
      leading: Icon(Icons.cloud_upload),
      title: Text('Save all'),
      onTap: () => {
        MyApp.cloud
            .uploadAllAndOverwrite()
            .then((value) => {
                  if (value)
                    this.showSnackBar(Text('Upload successful'))
                  else
                    this.showSnackBar(Text('Upload unsuccessful'))
                })
            .catchError((e) {
          this.showSnackBar(Text('Login before uploading'));
        }),
        this.setParentState.call(),
        Navigator.of(context).pop()
      },
    ));

    list.add(ListTile(
        leading: Icon(Icons.cloud_download),
        title: Text('Download all'),
        onTap: () => {
              MyApp.cloud
                  .downloadAllAndOverwrite(() {
                    this.setParentState.call();
                  })
                  .then((value) =>
                      {this.showSnackBar(Text('Download successful'))})
                  .catchError((e) {
                    this.showSnackBar(Text('Login before downloading'));
                  }),
              Navigator.of(context).pop()
            }));

    return list;
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
          MyApp.auth.logOut().whenComplete(
              () => {this.showSnackBar(Text('Logged out successfully'))}),
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
              child: ListView(children: _createLoginList()),
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

  List<Widget> _createLoginList() {
    List<Widget> list = List();
    list.add(ListTile(
      leading: Icon(Icons.input),
      title: Text('Login with Google'),
      onTap: () => {
        MyApp.auth.signInWithGoogle(
            callback: (user) => {

                  this.setParentState.call(),
                  this.showSnackBar(Text('Signed in as ' + user.displayName))
                }),
        Navigator.of(context).pop(),
        this.popParent.call()
      },
    ));
    if (MyApp.debug)
      list.addAll([
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
        )
      ]);
    return list;
  }
}
