import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/bloc/login_bloc.dart';
import 'package:insta_clone/main.dart';
import 'package:insta_clone/screens/FeedScreen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginBloc bloc = BlocInheritedClass.of(context).loginBloc;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                child: Image.asset(
                  'assets/insta.png',
                ),
              ),
              StreamBuilder<String>(
                  stream: bloc.email,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: snapshot.error,
                        ),
                        onChanged: bloc.emailChanged,
                      ),
                    );
                  }),
              StreamBuilder<String>(
                  stream: bloc.password,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          errorText: snapshot.error,
                        ),
                        obscureText: true,
                        onChanged: bloc.passwordChanged,
                      ),
                    );
                  }),
//              StreamBuilder<String>(
//                  stream: bloc.error,
//                  builder: (context, snapshot) {
//                    if (snapshot.hasData)
//                      return Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Text(snapshot.error));
//                    else {
////                      debugPrint(snapshot.data);
//                      return SizedBox();
//                    }
//                  }),
              StreamBuilder<bool>(
                stream: bloc.verifiedUser,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      child: Text("Login"),
                      color: snapshot.hasData ? Colors.blue : Colors.grey,
                      onPressed: () {
                        if (snapshot.hasData ?? false) {
                          bloc.signIn();
                          if (bloc.uuid != '')
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FeedScreen()));
                        }
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Text("Sign Up"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignUpScreen()));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  changeThePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FeedScreen()));
  }
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginBloc bloc = LoginBloc();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                child: Image.asset(
                  'assets/insta.png',
                ),
              ),
              StreamBuilder<String>(
                  stream: bloc.name,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'name',
                          errorText: snapshot.error,
                        ),
                        onChanged: bloc.nameChanged,
                      ),
                    );
                  }),
              StreamBuilder<String>(
                  stream: bloc.username,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'username',
                          errorText: snapshot.error,
                        ),
                        onChanged: bloc.usernameChanged,
                      ),
                    );
                  }),
              StreamBuilder<String>(
                  stream: bloc.email,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: snapshot.error,
                        ),
                        onChanged: bloc.emailChanged,
                      ),
                    );
                  }),
              StreamBuilder<String>(
                  stream: bloc.password,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'password',
                          errorText: snapshot.error,
                        ),
                        onChanged: bloc.passwordChanged,
                      ),
                    );
                  }),
//              StreamBuilder<String>(
//                  stream: bloc.bio,
//                  builder: (context, snapshot) {
//                    return Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: TextField(
//                        decoration: InputDecoration(
//                          labelText: 'bio',
//                          errorText: snapshot.error,
//                        ),
//                        onChanged: bloc.emailChanged,
//                      ),
//                    );
//                  }),
//              StreamBuilder<String>(
//                  stream: bloc.url,
//                  builder: (context, snapshot) {
//                    return Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: TextField(
//                        decoration: InputDecoration(
//                          labelText: 'image',
//                          errorText: snapshot.error,
//                        ),
//                        onChanged: bloc.emailChanged,
//                      ),
//                    );
//                  }),
              StreamBuilder<bool>(
                stream: bloc.addUser,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      child: Text("Sign Up"),
                      color: snapshot.hasData ? Colors.blue : Colors.grey,
                      onPressed: () {
                        if (snapshot.hasData ?? false) {
                          debugPrint('yess');bloc.signUp();
//                          signUp(bloc.email, bloc.password, bloc.username,
//                              bloc.name, context);
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  signUp(Stream<String> email, Stream<String> password, Stream<String> username,
      Stream<String> name, context) async {
    try {
      List<String> d = await Future.wait(
          [ password.first, username.first, name.first]);
      debugPrint(d.toString());
      String e = d[0];
      String p = d[1];
      String u = d[2];
      String n = d[3];
      debugPrint('egge');
      AuthResult user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: e, password: p);
      final token = user.user.uid;
      DatabaseReference _reference =
          FirebaseDatabase.instance.reference().child('users').child(token);

      HashMap _hashMap = HashMap.fromEntries([
        MapEntry('id', token),
        MapEntry('username', u),
        MapEntry('name', n),
        MapEntry('password', p),
        MapEntry('email', e),
        //      MapEntry('bio', bio),
        //      MapEntry('url', url),
      ]);

      _reference.set(_hashMap).whenComplete(() {
        Navigator.of(context).pop();
      });
    } catch (e) {
      debugPrint("ERROR - $e");
    }
  }
}
