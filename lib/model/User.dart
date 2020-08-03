class User {
  String _name;
  String _email;
  String _password;

  String get name => _name;
  String get email => _email;
  String get passoword => _password;

  void saveUser(String name, String email, String password) {
    this._name = name;
    this._email = email;
    this._password = password;
  }
}