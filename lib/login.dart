import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterwhatsapp/resources/AppColors.dart';
import 'package:flutterwhatsapp/resources/AppStrings.dart';
import 'package:flutterwhatsapp/resources/Images.dart';
import 'package:flutterwhatsapp/signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override

  // handler login
  void doLogin() {
    // ...
  }

  // handler signup

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: AppColors.primaryCollor),
      padding: EdgeInsets.all(8),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(32),
                child: Image.asset(
                  Images.logo,
                  width: 300,
                  height: 150,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: AppStrings.emailHint,
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    filled: true,
                    fillColor: AppColors.textFieldBackground,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: AppStrings.passwordHint,
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    filled: true,
                    fillColor: AppColors.textFieldBackground,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: RaisedButton(
                  child: Text(
                    AppStrings.btnLogin,
                    style: TextStyle(fontSize: 20),
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  onPressed: () {
                    doLogin();
                  },
                ),
              ),
              Center(
                  child: Padding(
                padding: EdgeInsets.all(16),
                child: GestureDetector(
                  child: Text(
                    AppStrings.btnSignUpPhase,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                ),
              ))
            ],
          ),
        ),
      ),
    ));
  }
}
