import 'package:firebase_auth/firebase_auth.dart';

class User {
  String _name;
  String _email;
  String _password;

  String get name => _name;
  String get email => _email;
  String get passoword => _password;
  
  String get nameFirebaseKey => "name";
  String get emailFirebaseKey => "email";
  String get passowordFirebaseKey => "passoword";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": this.name,
      "email": this.email
    };

    return map;
  }

  void saveUser(String name, String email, String password) {
    this._name = name;
    this._email = email;
    this._password = password;
  }

  static Future<FirebaseUser> getFireabseUser() async {
    FirebaseAuth authInstance = FirebaseAuth.instance;
    FirebaseUser user = await authInstance.currentUser();
    return user;
  }
}