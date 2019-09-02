import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_clone/bloc/content_bloc.dart';
import 'package:insta_clone/bloc/classes.dart';
import '../main.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ContentBloc contentBlocPattern = BlocInheritedClass.of(context).contentBloc;
    return StreamBuilder<List<dynamic>>(
      stream: contentBlocPattern.feedWithUserData,
      builder: (context, snapshot) {
        if ((snapshot.hasData ?? false) && snapshot.data[0].length > 0)
          return ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircleAvatar(
                          child: (snapshot.hasData ?? false) &&
                                  snapshot.data != null &&
                                  snapshot.data[1] != null
                              ? Image.network(snapshot.data[1].length >= index
                                  ? snapshot.data[1][index]['url']
                                  : noPic)
                              : Text(
                                  '',
                                  textScaleFactor: 0,
                                ),
                          radius: 20,
                          backgroundColor: Colors.white,
                        ),
                        Text((snapshot.hasData ?? false) &&
                                snapshot.data != null &&
                                snapshot.data[1] != null
                            ? snapshot.data[1][index]['username']
                            : ''),
                        Spacer(),
                        Icon(Icons.menu)
                      ],
                    ),
                    Container(
                      child: Image.network(
                          Post.fromMap(snapshot.data[0][index]).url),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if ((snapshot.hasData ?? false) &&
                                  snapshot.data != null)
                                contentBlocPattern.likePost(
                                    Post.fromMap(snapshot.data[0][index]).id,
                                    !(snapshot.data[3][index]));
                              contentBlocPattern.getFeed();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Icon(
                                FontAwesomeIcons.heart,
                                color: (snapshot.hasData ?? false) &&
                                        snapshot.data != null &&
                                        snapshot.data[3] != null &&
                                        snapshot.data[3].length >= index &&
                                        snapshot.data[3][index]
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Icon(FontAwesomeIcons.comment),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Icon(FontAwesomeIcons.paperPlane),
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Icon(FontAwesomeIcons.tag),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "${snapshot.data != null ? snapshot.data[2][index] : 0} likes",
                        textScaleFactor: 0.7,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 4.0),
                            child: Text(
                              (snapshot.hasData ?? false) &&
                                      snapshot.data != null
                                  ? snapshot.data[1][index]['username']
                                  : '',
                              textScaleFactor: 0.7,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 4.0, right: 8.0),
                            child: Text(
                              Post.fromMap(snapshot.data[0][index]).description,
                              textScaleFactor: 0.7,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "View all ${0} comments",
                        textScaleFactor: 0.7,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: snapshot.hasData ?? false ? snapshot.data[0].length : 0,
          );
        else if ((snapshot.hasData ?? true) &&
            (snapshot.data == null || snapshot.data[0].length == 0))
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Text('No user followed or no posts found'),
            ),
          );
        else {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Text('Feed loading'),
            ),
          );
        }
      },
    );
  }
}
