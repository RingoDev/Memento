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

  upload(File jsonFile) async {
    if (this.user == null) {
      // second chance
      FirebaseUser refreshedUser = await MyApp.auth.refreshUser();
      if (refreshedUser == null) return;
    }

    print('uploading data');
    final StorageReference firebaseStorageRef =
        this.storage.ref().child('user/' + this.user.uid);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(jsonFile);

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return CloudStorageResult(
        url: url,
        fileName: this.user.uid,
      );
    }
    return null;
  }

  uploadAll() async {
    String encoded = jsonEncode(MyApp.model);
    final directory = await Directory.systemTemp.createTemp();
    File temp = File(directory.path + '/' + 'tempfile.json');
    temp.createSync();
    temp.writeAsStringSync(encoded);
    var result = await MyApp.cloud.upload(temp);
    temp.delete();
    return result;
  }

  download() async {
    if (this.user == null) {
      // second chance
      FirebaseUser refreshedUser = await MyApp.auth.refreshUser();
      if (refreshedUser == null) return;
    }
    print('downloading data');
    final StorageReference firebaseStorageRef =
        this.storage.ref().child('user/' + this.user.uid);

    final ONE_MEGABYTE = 1024 * 1024;

    var json = await firebaseStorageRef.getData(ONE_MEGABYTE);
    return utf8.decode(json);
  }

  Future<Model> downloadAll() async {
    String jsonString = await download();
    Model model = Model.fromJson(jsonDecode(jsonString));
    return model;
  }

  downloadAllAndOverwrite(VoidCallback callback) async {
    Future<Model> modelFuture = downloadAll();
    modelFuture
        .then((value) => {
              MyApp.model = value,
              DBController.instance.deleteAll(),
              MyApp.model.todoLists.forEach((element) {
                DBController.instance.insert(element);
              })
            })
        .whenComplete(() => callback.call());
  }
}

class CloudStorageResult {
  final String url;
  final String fileName;

  CloudStorageResult({this.url, this.fileName});
}
