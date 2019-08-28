import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 30),
              child: Text("Username"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    child: Image.network(
                        'https://images.pexels.com/photos/2806517/pexels-photo-2806517.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                    backgroundColor: Colors.white,
                    radius: 60,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Posts'),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Followers'),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Following'),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "NAme",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("BIO here"),
            ),
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
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 12,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Image.network(
                        'https://images.pexels.com/photos/2331572/pexels-photo-2331572.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
