import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:memento/Data/model.dart';
import 'package:memento/Database/db_controller.dart';

import '../main.dart';

class CloudController {
  final FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseUser user;

  CloudController() {
    MyApp.auth.addCallback(() {
      this.user = MyApp.auth.user;
    });
  }

  /// returns user if logged in, otherwise throws exception
  Future<FirebaseUser> checkLogin() async {
    if (this.user == null) {
      // second chance
      this.user = await MyApp.auth.refreshUser();
      if (this.user == null) throw Exception('Not logged in');
    }
    return this.user;
  }

  /// uploads a User specific File to the cloud storage
  /// returns true if task is uploaded successfully and false if not.
  Future<bool> upload(File jsonFile) async {
    this.user = await checkLogin();

    print('uploading data');
    final StorageReference firebaseStorageRef =
        this.storage.ref().child('user/' + this.user.uid);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(jsonFile);

    await uploadTask.onComplete;

    return uploadTask.isComplete;
  }

  /// uploads the whole model to the cloud storage and overwrites old data
  Future<bool> uploadAllAndOverwrite() async {
    // if not logged in throw error
    this.user = await checkLogin();
    String encoded = jsonEncode(MyApp.model);
    final directory = await Directory.systemTemp.createTemp();
    File temp = File(directory.path + '/' + 'tempfile.json');
    temp.createSync();
    temp.writeAsStringSync(encoded);
    bool result = await MyApp.cloud.upload(temp);
    await temp.delete();
    return result;
  }

  /// downloads the user File and returns it as a String
  Future<String> download() async {
    this.user = await checkLogin();

    print('downloading data');
    final StorageReference firebaseStorageRef =
        this.storage.ref().child('user/' + this.user.uid);

    final ONE_MEGABYTE = 1024 * 1024;

    var json = await firebaseStorageRef.getData(ONE_MEGABYTE);
    return utf8.decode(json);
  }

  /// if no error is forwarded, download was successful
  Future<Model> downloadAll() async {
    Model model;
    await download()
        .then((value) => {model = Model.fromJson(jsonDecode(value))});
    return model;
  }

  /// if no error is forwarded, download and override were successful
  Future<void> downloadAllAndOverwrite(VoidCallback callback) async {
    await downloadAll().then((value) async {
      MyApp.model = value;
      await DBController.instance.deleteAll();
      MyApp.model.todoLists.forEach((element) async {
        await DBController.instance.insert(element);
      });
    }).whenComplete(() => callback.call());
  }
}