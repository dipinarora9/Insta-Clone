import 'package:rxdart/rxdart.dart';

class ContentBloc {
  final _usernameController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _bioController = BehaviorSubject<String>();
  final _urlController = BehaviorSubject<String>();
  final _errorController = BehaviorSubject<String>();


  void dispose() {
    _usernameController?.close();
    _passwordController?.close();
    _emailController?.close();
    _nameController?.close();
    _bioController?.close();
    _urlController?.close();
    _errorController?.close();
  }
}
