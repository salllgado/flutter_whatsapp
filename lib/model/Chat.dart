class Chat {

  String _name;
  String _lastMessage;
  String _photoUrl;

  Chat(this._name, this._lastMessage, this._photoUrl);

  set(String name, String lastMessage, String photoUrl) {
    this._name = name;
    this._lastMessage = lastMessage;
    this._photoUrl = photoUrl;
  }

  String get name => _name;
  String get lastMessage => _lastMessage;
  String get photoUrl => _photoUrl;

}