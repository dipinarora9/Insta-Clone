import 'package:flutter/material.dart';
import 'package:insta_clone/bloc/bloc_pattern.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Bloc();
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
              StreamBuilder<String>(
                  stream: bloc.error,
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.error));
                    else
                      return SizedBox();
                  }),
              StreamBuilder<bool>(
                stream: bloc.verifiedUser,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      child: Text("Login"),
                      color: snapshot.hasData ? Colors.blue : Colors.grey,
                      onPressed: () {
                        //todo: just for ui
                        debugPrint(snapshot.data.toString());
                        if (snapshot.hasData ?? false)
                          Navigator.of(context).pushNamed('/initial');
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
                        builder: (context) => SignUpScreen(bloc)));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  SignUpScreen(this.bloc);

  final Bloc bloc;

  @override
  Widget build(BuildContext context) {
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
              StreamBuilder<bool>(
                stream: bloc.verifiedUser,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      child: Text("Login"),
                      onPressed: () {
                        //todo: just for ui

                        if (snapshot.hasData ?? false)
                          Navigator.of(context).pushNamed('/initial');
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
                    Navigator.of(context).pushNamed('/signup');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
