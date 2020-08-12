class Contact {
  String _name;
  String _photoUrl;

  Contact(this._name, this._photoUrl);

  set(String name, String photoUrl) {
    this._name = name;
    this._photoUrl = photoUrl;
  }

  String get name => _name;
  String get photoUrl => _photoUrl;
}