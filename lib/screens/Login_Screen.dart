import 'package:flutter/material.dart';
import 'package:insta_clone/bloc/login_bloc.dart';
import 'package:insta_clone/main.dart';
import 'package:insta_clone/screens/FeedScreen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginBloc loginBlocPattern = BlocInheritedClass.of(context).loginBloc;
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
                  stream: loginBlocPattern.email,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: snapshot.error,
                        ),
                        onChanged: loginBlocPattern.emailChanged,
                      ),
                    );
                  }),
              StreamBuilder<String>(
                  stream: loginBlocPattern.password,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          errorText: snapshot.error,
                        ),
                        obscureText: true,
                        onChanged: loginBlocPattern.passwordChanged,
                      ),
                    );
                  }),
              StreamBuilder<String>(
                  stream: loginBlocPattern.error,
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.error));
                    else {
                      return SizedBox();
                    }
                  }),
              StreamBuilder<List<String>>(
                stream: loginBlocPattern.verifiedUser,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      child: Text("Login"),
                      color: snapshot.hasData ? Colors.blue : Colors.grey,
                      onPressed: () {
                        if (snapshot.hasData ?? false) {
                          loginBlocPattern.signIn(
                              snapshot.data[0], snapshot.data[1], context);
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
              StreamBuilder<List<String>>(
                stream: bloc.addUser,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      child: Text("Sign Up"),
                      color: snapshot.hasData ? Colors.blue : Colors.grey,
                      onPressed: () {
                        if (snapshot.hasData ?? false) {
                          bloc.signUp(snapshot.data[0], snapshot.data[1],
                              snapshot.data[2], snapshot.data[3]);
                          Navigator.of(context).pop();
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
}
