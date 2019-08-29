import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContentBloc {
//  Future<FirebaseUser> get user => FirebaseAuth.instance.currentUser();
  final _usersController = BehaviorSubject<List>();
  final _queryController = BehaviorSubject<String>();

  Stream<List> get users => _usersController.stream;

  Stream<String> get query => _queryController.stream;

  Function(String) get queryAdded => _queryController.sink.add;

  follow() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final token = user.uid;
    DatabaseReference _reference = FirebaseDatabase.instance
        .reference()
        .child('follow')
        .child(token)
        .child('following');
  }

  search(String query) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    Query _reference = FirebaseDatabase.instance
        .reference()
        .child('users')
        .orderByChild('username')
        .startAt(_queryController.value)
        .endAt(_queryController.value + "\uf8ff");
    debugPrint(_reference.toString());
  }

//  set user(FirebaseUser user) => this._user = user;

  void dispose() {
    _usersController?.close();
    _queryController?.close();
  }
}
