class Contact {
  String _userId;
  String _name;
  String _email;
  String _photoUrl;

  Contact(this._userId, this._name, this._email, this._photoUrl);

  set(String userId, String name, String email, String photoUrl) {
    this._userId = userId;
    this._name = name;
    this._email = email;
    this._photoUrl = photoUrl;
  }

  String get userId => _userId;
  String get name => _name;
  String get photoUrl => _photoUrl;

  static String get userIdFirebaseKey => "userId";
  static String get nameFirebaseKey => "name";
  static String get emailFirebaseKey => "email";
  static String get photoUrlFirebaseKey => "imageUrl";

}