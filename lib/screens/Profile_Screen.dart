import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/bloc/content_bloc.dart';
import 'package:insta_clone/screens/ListBuiler_Screen.dart';
import '../main.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({this.hide});

  final bool hide;

  @override
  Widget build(BuildContext context) {
    ContentBloc contentBlocPattern = BlocInheritedClass.of(context).contentBloc;
    return WillPopScope(
      onWillPop: () {
        contentBlocPattern.profileData();
        contentBlocPattern.hider(null);
        Navigator.of(context).pop();
        return Future(() => false);
      },
      child: StreamBuilder<List<dynamic>>(
        stream: contentBlocPattern.profileScreenData,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0).copyWith(top: 40),
                    child: Text(snapshot.hasData ?? false
                        ? snapshot.data[0].username
                        : ''),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        if (snapshot.hasData ?? false)
                          CircleAvatar(
                            child: Image.network(snapshot.data[0].url),
                            backgroundColor: Colors.white,
                            radius: 60,
                          ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(snapshot.hasData ?? false
                                  ? snapshot.data[1].length.toString()
                                  : '0'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Posts'),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            contentBlocPattern.getUsersData(snapshot.data[2]);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ListBuilderScreen('Followers'),
                              ),
                            );
                          },
                          child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.hasData ?? false
                                      ? snapshot.data[2].length.toString()
                                      : '0'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Followers'),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            contentBlocPattern.getUsersData(snapshot.data[3]);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ListBuilderScreen('Following'),
                              ),
                            );
                          },
                          child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.hasData ?? false
                                      ? snapshot.data[3].length.toString()
                                      : '0'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Following'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      snapshot.hasData ?? false ? snapshot.data[0].name : '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                        snapshot.hasData ?? false ? snapshot.data[0].bio : ''),
                  ),
                  if (hide != null)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: StreamBuilder<bool>(
                          stream: contentBlocPattern.hide,
                          builder: (context, hideSnap) {
                            return Container(
                              width: MediaQuery.of(context).size.width - 20,
                              child: FlatButton(
                                color: hideSnap.hasData ?? false
                                    ? hideSnap.data
                                        ? Colors.red.withOpacity(0.5)
                                        : Colors.blue.withOpacity(0.5)
                                    : hide
                                        ? Colors.red.withOpacity(0.5)
                                        : Colors.blue.withOpacity(0.5),
                                onPressed: () {
                                  contentBlocPattern.follow(
                                      snapshot.data[0].id,
                                      hideSnap.hasData ?? false
                                          ? hideSnap.data ? false : true
                                          : hide ? false : true,
                                      add: true);
                                  contentBlocPattern.profileData(
                                      uid: snapshot.data[0].id);
                                },
                                child: Text(
                                  hideSnap.hasData ?? false
                                      ? hideSnap.data ? 'Following' : "Follow"
                                      : hide ? 'Following' : "Follow",
                                  textScaleFactor: 0.7,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  if (hide == null)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        child: OutlineButton(
                          onPressed: null,
                          child: Text(
                            "Edit Profile",
                            textScaleFactor: 0.7,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (hide == null)
                    GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 20,
                          child: OutlineButton(
                            onPressed: null,
                            child: Text(
                              "Sign Out",
                              textScaleFactor: 0.7,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ((snapshot.hasData ?? false) && snapshot.data[1].length != 0)
                      ? Expanded(
                          child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data[1].length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Image.network(snapshot.data[1].values
                                  .toList()[index]['postimage']),
                            );
                          },
                        ))
                      : Padding(
                          child: Center(
                            child: Text('No posts'),
                          ),
                          padding: EdgeInsets.all(20),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
