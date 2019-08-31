import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContentBloc extends Object with Validate implements Disposer {
  final _usersController = BehaviorSubject<Map<dynamic, dynamic>>();
  final _followController = BehaviorSubject<Map<dynamic, dynamic>>();
  final _queryController = BehaviorSubject<String>();
  final _uploading = BehaviorSubject<bool>();
  final _file = BehaviorSubject<File>();
  final _description = BehaviorSubject<String>();

  Stream<Map<dynamic, dynamic>> get users => _usersController.stream;

  Function(String) get descriptionChanged => _description.sink.add;

  Stream<Map<dynamic, dynamic>> get follower => _followController.stream;

  Stream<String> get query => _queryController.stream;

  Stream<String> get description => _description.stream;

  Stream<File> get file => _file.stream;

  Stream<List<dynamic>> get fileWithDescription =>
      Observable.combineLatest2(file, description, (f, d) => [f, d]);

  Stream<List<dynamic>> get fetchedData =>
      Observable.combineLatest2(users, follower, (u, f) => [u, f]);

  follow(String id, bool follow) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final token = user.uid;
    if (follow)
      FirebaseDatabase.instance
          .reference()
          .child('follow')
          .child(token)
          .child('following')
          .child(id)
          .set(follow);
    else
      FirebaseDatabase.instance
          .reference()
          .child('follow')
          .child(token)
          .child('following')
          .child(id)
          .remove();
  }

  followerChecker(String id) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final token = user.uid;
    Query _reference = FirebaseDatabase.instance
        .reference()
        .child('follow')
        .child(token)
        .child('following');
    _reference.onValue.listen((data) {
      _followController.add(data.snapshot.value);
    });
  }

  getFeed() async {
//    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    final token = user.uid;
//    Query _reference = FirebaseDatabase.instance
//        .reference()
//        .child('follow')
//        .child(token)
//        .child('following');
//    _reference.onValue.listen((data) {
//      _followController.add(data.snapshot.value);
//    });
  }

  search(String query) {
    Query _reference = FirebaseDatabase.instance
        .reference()
        .child('users')
        .orderByChild('username')
        .startAt(query)
        .endAt(query + "\uf8ff");
    _reference.onValue.listen((data) {
      followerChecker(data.snapshot.value.keys.toList()[0]);
      _usersController.add(data.snapshot.value);
    });
  }

  Future<Null> openImagePicker() async {
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    _file.sink.add(pick);
  }

  upload(File file, String descriptionData) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file.path.split('.').last);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    StorageUploadTask token = storageReference.putFile(file);
    StorageTaskSnapshot d = await token.onComplete;
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('posts');

    String postID = databaseReference.push().key;
    debugPrint(d.uploadSessionUri.data.toString());
    HashMap _hashMap = HashMap.fromEntries([
      MapEntry('postid', postID),
      MapEntry('postimage', d.uploadSessionUri.data),
      MapEntry('description', descriptionData),
      MapEntry('publisher', user.uid),
    ]);

    databaseReference.child(postID).set(_hashMap);
  }

  void dispose() {
    _usersController?.close();
    _queryController?.close();
    _followController?.close();
    _uploading?.close();
    _file?.close();
    _description?.close();
  }
}

abstract class Disposer {
  void dispose();
}

mixin Validate {
  var parser =
      StreamTransformer<Event, Event>.fromHandlers(handleData: (data, sink) {
    debugPrint(data.snapshot.value.toString());
  });
}
