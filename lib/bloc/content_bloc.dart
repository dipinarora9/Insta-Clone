import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContentBloc extends Object with Validate implements Disposer {
  final _usersController = BehaviorSubject<Map<dynamic, dynamic>>();
  final _followController = BehaviorSubject<Map<dynamic, dynamic>>();
  final _queryController = BehaviorSubject<String>();

  Stream<Map<dynamic, dynamic>> get users => _usersController.stream;

  Stream<Map<dynamic, dynamic>> get follower => _followController.stream;

  Stream<String> get query => _queryController.stream;

  Stream<List<dynamic>> get fetchedData =>
      Observable.combineLatest2(users, follower, (u, f) => [u, f]);

//  Function(String) get queryAdded => _queryController.sink.add;

  follow(String id, bool follow) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final token = user.uid;
    FirebaseDatabase.instance
        .reference()
        .child('follow')
        .child(token)
        .child('following')
        .child(id)
        .set(follow);
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
      debugPrint(data.snapshot.value.toString());
      data.snapshot.value.removeWhere((k, v) => v == false);
      _followController.add(data.snapshot.value);
    });
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

//  set user(FirebaseUser user) => this._user = user;

  void dispose() {
    _usersController?.close();
    _queryController?.close();
    _followController?.close();
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
