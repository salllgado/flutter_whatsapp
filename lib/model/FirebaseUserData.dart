import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserData {

  static Future<FirebaseUser> getFireabseUser() async {
    FirebaseAuth authInstance = FirebaseAuth.instance;
    FirebaseUser user = await authInstance.currentUser();
    return user;
  }

  static Future<String> getFireabseUserId() async {
    FirebaseAuth authInstance = FirebaseAuth.instance;
    FirebaseUser user = await authInstance.currentUser();
    return user.uid;
  }
}