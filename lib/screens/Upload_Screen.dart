import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insta_clone/bloc/content_bloc.dart';

import '../main.dart';

class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ContentBloc contentBlocPattern = BlocInheritedClass.of(context).contentBloc;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () {
              contentBlocPattern.openImagePicker();
            },
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Choose Image",
                    style: TextStyle(
                      fontFamily: "Questrial",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<File>(
              stream: contentBlocPattern.file,
              builder: (context, snapshot) {
                if (snapshot.hasData ?? false)
                  return Container(
                    child: Image.file(snapshot.data),
                    width: MediaQuery.of(context).size.width - 20,
                    height: MediaQuery.of(context).size.height / 2,
                  );
                return Text(
                  '',
                  textScaleFactor: 0,
                );
              }),
        ),
        Expanded(
          child: StreamBuilder<String>(
              stream: contentBlocPattern.description,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    onChanged: contentBlocPattern.descriptionChanged,
                  ),
                );
              }),
        ),
        Expanded(
          child: StreamBuilder<List<dynamic>>(
              stream: contentBlocPattern.fileWithDescription,
              builder: (context, snapshot) {
                if (snapshot.hasData ?? false)
                  return InkWell(
                    onTap: () {
                      contentBlocPattern.upload(
                          snapshot.data[0], snapshot.data[1]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "upload",
                            style: TextStyle(
                              fontFamily: "Questrial",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                return Text(
                  '',
                  textScaleFactor: 0,
                );
              }),
        ),
      ],
    );
  }
}
