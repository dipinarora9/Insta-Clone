import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/main.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginBloc extends Object with Validate implements Disposer {
  final _usernameController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _bioController = BehaviorSubject<String>();
  final _urlController = BehaviorSubject<String>();
  final _errorController = BehaviorSubject<String>();

  bool _signUp = false;
  String _uuid = '';

  String get uuid => _uuid;

  bool get signedUp => _signUp;

  Function(String) get emailChanged => _emailController.sink.add;

  Function(String) get passwordChanged => _passwordController.sink.add;

  Function(String) get usernameChanged => _usernameController.sink.add;

  Function(String) get nameChanged => _nameController.sink.add;

  Stream<String> get username =>
      _usernameController.stream.transform(usernameChecker);

  Stream<String> get name => _nameController.stream.transform(usernameChecker);

//  Stream<String> get bio => _bioController.stream;
//
  Stream<String> get error =>
      _errorController.stream.transform(errorAdder);

//
//  Stream<String> get url => _urlController.stream;

  Stream<String> get email => _emailController.stream.transform(emailChecker);

  Stream<String> get password =>
      _passwordController.stream.transform(passChecker);

  Stream<List<String>> get addUser => Observable.combineLatest4(
      email, password, username, name, (e, p, u, n) => [e, p, u, n]);

  Stream<List<String>> get verifiedUser =>
      Observable.combineLatest2(email, password, (e, p) => [e, p]);

  signUp(String email, String pass, String username, String name) async {
    try {
      debugPrint('$email  $pass');
      final AuthResult user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
      final token = user.user.uid;
      DatabaseReference _reference =
          FirebaseDatabase.instance.reference().child('users').child(token);

      HashMap _hashMap = HashMap.fromEntries([
        MapEntry('id', token),
        MapEntry('username', username),
        MapEntry('name', name),
        MapEntry('password', pass),
        MapEntry('email', email),
        //      MapEntry('bio', bio),
        //      MapEntry('url', url),
      ]);
      _reference.set(_hashMap).whenComplete(() {
        _signUp = true;
      });
    } catch (e) {
      debugPrint('ERRROROR - $e');
      _signUp = false;
    }
  }

  signIn(String email, String pass, context) async {
    final FirebaseAuth _instance = FirebaseAuth.instance;
    try {
      final AuthResult token = await _instance.signInWithEmailAndPassword(
          email: email, password: pass);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => InitialScreen()));
    } catch (e) {
      debugPrint('errrrrror');
      _errorController.sink.addError('Error Sigining In');
    }
  }

  @override
  void dispose() {
    _usernameController?.close();
    _passwordController?.close();
    _emailController?.close();
    _nameController?.close();
    _bioController?.close();
    _urlController?.close();
    _errorController?.close();
  }
}

abstract class Disposer {
  void dispose();
}

mixin Validate {
  var emailChecker =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@'))
      sink.add(email);
    else
      sink.addError('Email not correct');
  });
  var usernameChecker = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) async {
    //todo

    sink.add(username);
  });
  var passChecker =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    if (pass.length > 6)
      sink.add(pass);
    else
      sink.addError('Password too short');
  });
  var nameChecker =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 0)
      sink.add(name);
    else
      sink.addError('No name provided');
  });
  var urlChecker =
      StreamTransformer<String, String>.fromHandlers(handleData: (url, sink) {
    if (url != null)
      sink.add(url);
    else
      sink.add(
          'https://firebasestorage.googleapis.com/v0/b/insta-clone-c7d60.appspot.com/o/no%20image.jpg?alt=media&token=ef31be60-bf92-44f1-afdc-94bbb1f17f88');
  });
  var bioChecker =
      StreamTransformer<String, String>.fromHandlers(handleData: (bio, sink) {
    if (bio.length > 0)
      sink.add(bio);
    else
      sink.add('');
  });
  var errorAdder =
      StreamTransformer<String, String>.fromHandlers(handleData: (error, sink) {
    sink.addError(error);
  });
}
