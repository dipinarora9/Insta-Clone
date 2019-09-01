import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'classes.dart';

class ContentBloc implements Disposer {
  final _usersController = BehaviorSubject<Map<dynamic, dynamic>>();
  final _followController = BehaviorSubject<Map<dynamic, dynamic>>();
  final _queryController = BehaviorSubject<String>();
  final _file = BehaviorSubject<File>();
  final _description = BehaviorSubject<String>();
  final _feedData = BehaviorSubject<List<dynamic>>();
  final _currentUser = BehaviorSubject<User>();
  final _likeList = BehaviorSubject<List<bool>>();
  final _likes = BehaviorSubject<List<int>>();
  final _userDatas = BehaviorSubject<Map<dynamic, dynamic>>();

  Stream<Map<dynamic, dynamic>> get users => _usersController.stream;

  Stream<List<dynamic>> get feed => _feedData.stream;

  Stream<User> get currentUser => _currentUser.stream;

  Function(String) get descriptionChanged => _description.sink.add;

  Stream<Map<dynamic, dynamic>> get follower => _followController.stream;

  Stream<String> get query => _queryController.stream;

  Stream<String> get description => _description.stream;

  Stream<List<bool>> get liked => _likeList.stream;

  Stream<List<int>> get likes => _likes.stream;

  Stream<Map<dynamic, dynamic>> get userData => _userDatas.stream;

  Stream<File> get file => _file.stream;

  Stream<List<dynamic>> get feedWithUserData => Observable.combineLatest4(
      feed, userData, likes, liked, (f, u, l, ll) => [f, u, l, ll]);

  Stream<List<dynamic>> get fileWithDescription =>
      Observable.combineLatest2(file, description, (f, d) => [f, d]);

  Stream<List<dynamic>> get fetchedData =>
      Observable.combineLatest2(users, follower, (u, f) => [u, f]);

  follow(String id, bool follow) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final token = user.uid;
    if (follow)
      FirebaseDatabase.instance
          .reference()
          .child('follow')
          .child(token)
          .child('following')
          .child(id)
          .set(follow);
    else
      FirebaseDatabase.instance
          .reference()
          .child('follow')
          .child(token)
          .child('following')
          .child(id)
          .remove();
  }

  followerChecker() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final token = user.uid;
    Query _reference = FirebaseDatabase.instance
        .reference()
        .child('follow')
        .child(token)
        .child('following');
    _reference.onValue.listen((data) {
      _followController.add(data.snapshot.value);
    });
  }

  likePost(String postId, bool like) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final token = user.uid;
    debugPrint(postId);
    if (like)
      FirebaseDatabase.instance
          .reference()
          .child('likes')
          .child(postId)
          .child(token)
          .set(true);
    else
      FirebaseDatabase.instance
          .reference()
          .child('likes')
          .child(postId)
          .child(token)
          .remove();
  }

  getFeed() async {
    Query _reference = FirebaseDatabase.instance.reference().child('posts');
    followerChecker();
    List<String> keys = [];
    _reference.onValue.listen((data) {
      Map<dynamic, dynamic> feed = data.snapshot.value;
      if (_followController.value != null && feed != null) {
        feed.values.toList().forEach((post) {
          if (!_followController.value
              .containsKey(Post.fromMap(post).publisher))
            keys.add(Post.fromMap(post).id);
        });
        keys.forEach((k) {
          feed.remove(k);
        });
        getPosts(feed.values.toList());
      } else
        feed = {};
      _feedData.add(feed.values.toList());
    });
  }

  profileData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Query _reference =
        FirebaseDatabase.instance.reference().child('users').child(user.uid);
    _reference.onValue.listen((data) {
      _currentUser.add(User.fromMap(data.snapshot.value));
    });
  }

  getPosts(List<dynamic> mapData) async {
    List<String> user = [];
    List<String> ids = [];
    DatabaseReference _reference =
        FirebaseDatabase.instance.reference().child('users');
    mapData.forEach((post) {
      user.add(post['publisher'].toString());
      ids.add(post['postid'].toString());
    });
    DataSnapshot d = await _reference.once();
    Map<dynamic, dynamic> users = d.value;

    users.removeWhere((k, v) => !user.contains(k));
    _userDatas.add(users);
    getLikes(ids);
  }

  getLikes(List<String> ids) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final token = user.uid;
    List<int> likes = [];
    List<bool> liked = [];

    DatabaseReference _reference =
        FirebaseDatabase.instance.reference().child('likes');
    DataSnapshot dataa = await _reference.once();
    Map<dynamic, dynamic> likesData = dataa.value;
    debugPrint('data  -  $likesData');

    ids.forEach((id) {
      if (likesData.containsKey(id)) {
        if (likesData[id].containsKey(token))
          liked.add(true);
        else
          liked.add(false);
        likes.add(likesData[id].length);
      } else {
        liked.add(false);
        likes.add(0);
      }
    });
    _likes.add(likes);
    _likeList.add(liked);
  }

  search(String query) {
    Query _reference = FirebaseDatabase.instance
        .reference()
        .child('users')
        .orderByChild('username')
        .startAt(query)
        .endAt(query + "\uf8ff");
    _reference.onValue.listen((data) {
      followerChecker();
      _usersController.add(data.snapshot.value);
    });
  }

  Future<Null> openImagePicker() async {
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    _file.sink.add(pick);
  }

  upload(File file, String descriptionData) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            file.path.split('.').last);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    StorageUploadTask token = storageReference.putFile(file);
    StorageTaskSnapshot d = await token.onComplete;
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('posts');

    String postID = databaseReference.push().key;
    String donwloadUrl = await d.ref.getDownloadURL();
    HashMap _hashMap = HashMap.fromEntries([
      MapEntry('postid', postID),
      MapEntry('postimage', donwloadUrl),
      MapEntry('description', descriptionData),
      MapEntry('publisher', user.uid),
    ]);

    databaseReference.child(postID).set(_hashMap);
  }

  void dispose() {
    _usersController?.drain();
    _queryController?.drain();
    _followController?.drain();
    _file?.drain();
    _description?.drain();
    _feedData?.drain();
    _currentUser?.drain();
    _likes?.drain();
    _userDatas?.drain();
  }
}

abstract class Disposer {
  void dispose();
}

const String noPic =
    'https://firebasestorage.googleapis.com/v0/b/insta-clone-c7d60.appspot.com/o/no%20image.jpg?alt=media&token=ef31be60-bf92-44f1-afdc-94bbb1f17f88';
