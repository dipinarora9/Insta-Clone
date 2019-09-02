import 'package:flutter/material.dart';
import 'package:insta_clone/bloc/content_bloc.dart';
import 'package:insta_clone/screens/Profile_Screen.dart';
import '../main.dart';

class ListBuilderScreen extends StatelessWidget {
  ListBuilderScreen(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    ContentBloc contentBlocPattern = BlocInheritedClass.of(context).contentBloc;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: contentBlocPattern.listWithFollowDat,
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  contentBlocPattern.profileData(
                      uid: snapshot.data[0].keys.toList()[index]);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Scaffold(
                        body: ProfileScreen(hide:  snapshot.data[1] != null &&
                            snapshot.data[1].keys.toList().contains(
                                snapshot.data[0].keys.toList()[index]),),
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(snapshot.hasData ?? false
                      ? snapshot.data[0].values
                          .toList()[index]['name']
                          .toString()
                      : ''),
                  subtitle: Text(snapshot.hasData ?? false
                      ? snapshot.data[0].values
                          .toList()[index]['username']
                          .toString()
                      : ''),
                  trailing: FlatButton(
                    onPressed: () {
                      contentBlocPattern.follow(
                          snapshot.data[0].keys.toList()[index],
                          snapshot.data[1] != null &&
                                  snapshot.data[1].keys.toList().contains(
                                      snapshot.data[0].keys.toList()[index])
                              ? false
                              : true);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snapshot.data[1] != null
                            ? snapshot.data[1].keys.toList().contains(
                                    snapshot.data[0].keys.toList()[index])
                                ? 'Following'
                                : 'Follow'
                            : 'Follow'),
                      ),
                      color: snapshot.data[1] != null
                          ? snapshot.data[1].keys.toList().contains(
                                  snapshot.data[0].keys.toList()[index])
                              ? Colors.red.withOpacity(0.5)
                              : Colors.blue.withOpacity(0.5)
                          : Colors.blue.withOpacity(0.5),
                    ),
                  ),
                ),
              );
            },
            itemCount: snapshot.hasData ?? false ? snapshot.data[0].length : 0,
          );
        },
      ),
    );
  }
}
