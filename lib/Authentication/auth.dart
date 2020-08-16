import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  List<VoidCallback> callbacks;

  void addCallback(VoidCallback callback){
    this.callbacks.add(callback);
  }

  void _callCallbacks(){
    for(VoidCallback cb in this.callbacks){
      cb.call();
    }
  }

  refreshUser() async {
    FirebaseUser user = await _auth.currentUser();
    this.user = user;
    return user;
  }


  AuthController(){
    this.callbacks = List();
    _auth.onAuthStateChanged.listen((firebaseUser) {
      this.user = firebaseUser;
      print(firebaseUser);
      _callCallbacks();

    });
  }

  get loggedIn {
    return user==null ? false : true;
  }

  get userName {
    return user == null ? 'unnamed' : user.displayName;
  }

  get userIcon {
    Image m = _getUserImage();
    if (m == null) return Icon(Icons.file_download);
    return m;
  }

  signInWithGoogle({Function(FirebaseUser user) callback}) async {

    this.user = await _handleGoogleSignIn();
    _handleGoogleSignIn().then((user) {
      this.user=user;
      callback(user);
    });
  }

  /// returns a Firebase User future
  Future<FirebaseUser> _handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  _handleLogOut() async{
    await _auth.signOut();
  }

  Future<void> logOut() async{
    await _handleLogOut();
    this.user = null;
  }

  Image _getUserImage(){
    if (this.user == null) return null;
    else return Image.network(user.photoUrl);
  }
}
