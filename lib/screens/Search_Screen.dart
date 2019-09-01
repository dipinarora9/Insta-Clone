import 'package:flutter/material.dart';
import 'package:insta_clone/bloc/content_bloc.dart';

import '../main.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ContentBloc contentBlocPattern = BlocInheritedClass.of(context).contentBloc;
    return Container(
      child: Column(
        children: <Widget>[
          StreamBuilder<String>(
              stream: contentBlocPattern.query,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(top: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'username',
                      errorText: snapshot.error,
                    ),
                    onChanged: (v) {
                      contentBlocPattern.search(v);
                    },
                  ),
                );
              }),
          Expanded(
            child: StreamBuilder<List<dynamic>>(
              stream: contentBlocPattern.fetchedData,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        (snapshot.hasData ?? false) && snapshot.data[0] != null
                            ? snapshot.data[0].values.toList().length
                            : 1,
                    itemBuilder: (BuildContext context, int index) {
                      if ((snapshot.hasData ?? false) &&
                          snapshot.data[0] != null)
                        return ListTile(
                          title: Text(snapshot.data[0].values
                              .toList()[index]['username']
                              .toString()),
                          subtitle: Text(snapshot.data[0].values
                              .toList()[index]['name']
                              .toString()),
                          trailing: FlatButton(
                            onPressed: () {
                              contentBlocPattern.follow(
                                  snapshot.data[0].keys.toList()[index],
                                  snapshot.data[1] != null &&
                                          snapshot.data[1].keys
                                              .toList()
                                              .contains(snapshot.data[0].keys
                                                  .toList()[index])
                                      ? false
                                      : true);
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshot.data[1] != null
                                    ? snapshot.data[1].keys.toList().contains(
                                            snapshot.data[0].keys
                                                .toList()[index])
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
                        );
                      return Center(child: Text('No User Found'));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
