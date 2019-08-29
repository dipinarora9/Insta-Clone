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
                    onChanged: (v){
                      contentBlocPattern.queryAdded(v);
                      contentBlocPattern.search(v);
                    },
                  ),
                );
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return StreamBuilder<List>(
                    stream: contentBlocPattern.users,
                    builder: (context, snapshot) {
                      debugPrint(snapshot.data.toString());
                      return ListTile(
                        title: Text('titile'),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
