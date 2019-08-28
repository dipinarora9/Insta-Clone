import 'package:flutter/material.dart';
import 'screens/Login_Screen.dart';
import 'screens/FeedScreen.dart';
import 'screens/Message_Screen.dart';
import 'screens/Notification_Screen.dart';
import 'screens/Profile_Screen.dart';
import 'screens/Upload_Screen.dart';
import 'screens/Search_Screen.dart';

void main() => runApp(InstaApp());

class InstaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/feed': (BuildContext context) => FeedScreen(),
        '/upload': (BuildContext context) => UploadScreen(),
        '/search': (BuildContext context) => SearchScreen(),
        '/likes': (BuildContext context) => NotificationScreen(),
        '/profile': (BuildContext context) => ProfileScreen(),
        '/dm': (BuildContext context) => MessagesScreen(),
      },
    );
  }
}
