import 'package:flutter/material.dart';
import 'package:insta_clone/bloc/login_bloc.dart';
import 'package:insta_clone/bloc/content_bloc.dart';
import 'screens/Login_Screen.dart';
import 'screens/FeedScreen.dart';
import 'screens/Notification_Screen.dart';
import 'screens/Profile_Screen.dart';
import 'screens/Upload_Screen.dart';
import 'screens/Search_Screen.dart';
//import 'package:scoped_model/scoped_model.dart';

void main() {
  final LoginBloc loginBloc = LoginBloc();
  final ContentBloc contentBloc = ContentBloc();
  runApp(InstaApp(loginBloc, contentBloc));
}

class InstaApp extends StatelessWidget {
  InstaApp(this.loginBloc, this.contentBloc);

  final LoginBloc loginBloc;
  final ContentBloc contentBloc;

  @override
  Widget build(BuildContext context) {
    return BlocInheritedClass(
      loginBloc: loginBloc,
      contentBloc: contentBloc,
      child: MaterialApp(
        title: 'Instagram Clone',home: LoginScreen(),
//        home: ScopedModel<LoginBloc>(
//          child: LoginScreen(),
//          model: loginBloc,
//        ),
        theme: ThemeData(
            appBarTheme: AppBarTheme(color: Colors.white),
            primaryColor: Color(0xfffafafa)),
        debugShowCheckedModeBanner: false,
//      routes: <String, WidgetBuilder>{
//        '/initial': (BuildContext context) => InitialScreen(),
//        '/login': (BuildContext context) => LoginScreen(),
//        '/sigup': (BuildContext context) => SignUpScreen(),
//        '/dm': (BuildContext context) => MessagesScreen(),
//      },
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _pageIndex == 0
          ? AppBar(
              actions: <Widget>[Icon(Icons.send)],
              centerTitle: true,
              leading: Icon(Icons.camera_alt),
              title: Image.asset('assets/insta.png'),
            )
          : null,
      body: pageToShow(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text(
              '',
              textScaleFactor: 0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            title: Text(
              '',
              textScaleFactor: 0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_to_photos,
              color: Colors.black,
            ),
            title: Text(
              '',
              textScaleFactor: 0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            title: Text('', textScaleFactor: 0),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.image,
              color: Colors.black,
            ),
            title: Text(
              '',
              textScaleFactor: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget pageToShow() {
    switch (_pageIndex) {
      case 1:
        return SearchScreen();
        break;
      case 2:
        return UploadScreen();
        break;
      case 3:
        return NotificationScreen();
        break;
      case 4:
        return ProfileScreen();
        break;
      default:
        return FeedScreen();
    }
  }
}

class BlocInheritedClass extends InheritedWidget {
  final LoginBloc loginBloc;
  final ContentBloc contentBloc;
  final Widget child;

  BlocInheritedClass({this.loginBloc, this.contentBloc, this.child})
      : super(child: child);

  static BlocInheritedClass of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(BlocInheritedClass);

  @override
  bool updateShouldNotify(BlocInheritedClass oldWidget) =>
      loginBloc != oldWidget.loginBloc || contentBloc != oldWidget.contentBloc;
}
