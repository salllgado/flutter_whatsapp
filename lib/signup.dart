import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/resources/AppColors.dart';
import 'package:flutterwhatsapp/resources/AppStrings.dart';
import 'package:flutterwhatsapp/resources/Images.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import 'model/User.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // define controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _handlerSignup() {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // tratamento de erro e show de um alerta.
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        email.contains("@") &&
        password.length >= 6) {
      // success
      User user = User();
      user.saveUser(name, email, password);
      _saveUserOnFirebase(user);
    } else {
      // have some error
    }
  }

  void _saveUserOnFirebase(User user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.fetchSignInMethodsForEmail(email: user.email).then((value) => {
          if (value.isEmpty)
            {
              auth.createUserWithEmailAndPassword(
                      email: user.email, password: user.passoword)
                  .then((value) => {
                        // we go to main view controller
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()))
                      })
                  .catchError((onError) {
                debugPrint(onError.toString());
                // show error message for user.
              })
            } else {
              Navigator.pop(context)
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.signUpScreenTitle),
        ),
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
                      Images.usuario,
                      width: 120,
                      height: 120,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: AppStrings.nameHint,
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
                      controller: _emailController,
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
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
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
                        AppStrings.btnSignup,
                        style: TextStyle(fontSize: 20),
                      ),
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        this._handlerSignup();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
