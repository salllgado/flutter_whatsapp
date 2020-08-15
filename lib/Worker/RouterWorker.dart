import "package:flutter/material.dart";
import 'package:flutterwhatsapp/login.dart';

import '../home.dart';
import '../signup.dart';

class RouterWorker {
  static const initialRouteHome = "/";
  static const loginRouteName = "/login";
  static const signupRouteName = "/signup";
  static const homeRouteName = "/home";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRouteHome:
        return RouterWorker.navigateToLogin();
        break;
      case loginRouteName:
        return RouterWorker.navigateToLogin();
        break;
      case signupRouteName:
        return MaterialPageRoute(builder: (context) => SignUp());
        break;
      case homeRouteName:
        return MaterialPageRoute(builder: (context) => Home());
        break;
      default:
        return RouterWorker.navigateToLogin();
        break;
    }
  }

  static MaterialPageRoute<dynamic> navigateToLogin() {
    return MaterialPageRoute(builder: (_) => Login());
  }
}
