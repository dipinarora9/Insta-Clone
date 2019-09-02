class Post {
  /*{-Lnbg8ySjkFIeChqv7nb: {publisher: NsF1pLSCHogGB6DCo7GzWwHBYzI3, postid: -Lnbg8ySjkFIeChqv7nb, description: 123hrgrf},*/

  String _publisher;
  String _postId;
  String _description;
  String _url;

  String get publisher => this._publisher ?? '';

  String get id => this._postId ?? '';

  String get description => this._description ?? '';

  String get url => this._url ?? '';

  Post.fromMap(Map<dynamic, dynamic> map) {
    this._url = map['postimage'].toString();
    this._postId = map['postid'].toString();
    this._publisher = map['publisher'].toString();
    this._description = map['description'].toString();
  }
}

class User {
  String _username;
  String _name;
  String _bio;
  String _url;
  String _id;

  String get id => this._id ?? '';

  String get username => this._username ?? '';

  String get bio => this._bio ?? '';

  String get name => this._name ?? '';

  String get url => this._url ?? '';

  User.fromMap(Map<dynamic, dynamic> map) {
    this._username = map['username'].toString();
    this._id = map['id'].toString();
    this._name = map['name'].toString();
    this._bio = map['bio'].toString();
    this._url = map['url'].toString();
  }
}
