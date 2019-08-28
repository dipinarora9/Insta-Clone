import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedScreen extends StatelessWidget {
  final List<List<dynamic>> data = [
    [
      "username",
      "https://images.pexels.com/photos/2821824/pexels-photo-2821824.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      12,
      32,
      "caption"
    ],
    [
      "username",
      "https://images.pexels.com/photos/1749580/pexels-photo-1749580.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      12,
      32,
      "caption"
    ],
    [
      "username",
      "https://images.pexels.com/photos/2817902/pexels-photo-2817902.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      12,
      32,
      "caption"
    ],
    [
      "username",
      "https://images.pexels.com/photos/2827374/pexels-photo-2827374.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      12,
      32,
      "caption"
    ],
    [
      "username",
      "https://images.pexels.com/photos/2835436/pexels-photo-2835436.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      12,
      32,
      "caption"
    ]
  ];

  @override
  Widget build(BuildContext context) {
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
                    child: Image.network(data[index][1]),
                    radius: 20,
                    backgroundColor: Colors.white,
                  ),
                  Text(data[index][0]),
                  Spacer(),
                  Icon(Icons.menu)
                ],
              ),
              Container(
                child: Image.network(data[index][1]),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Icon(FontAwesomeIcons.heart),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Icon(FontAwesomeIcons.comment),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Icon(FontAwesomeIcons.paperPlane),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Icon(FontAwesomeIcons.tag),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "${data[index][2]} likes",
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
                      padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                      child: Text(
                        data[index][0],
                        textScaleFactor: 0.7,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                      child: Text(
                        data[index][4],
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
                  "View all ${data[index][2]} comments",
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
      itemCount: data.length,
    );
  }
}
