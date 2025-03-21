import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../ui/screen/auth/login_screen.dart';
import '../ui/screen/screen.dart';

class Routes {
  Routes._();

  //screen name
  static const String splashScreen = "/splashScreen";
  static const String loginScreen = "/loginScreen";

  //init screen name
  static String initScreen() => splashScreen;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return PageTransition(child: SplashScreen(), type: PageTransitionType.fade);
      case loginScreen:
        return PageTransition(child: LoginScreen(), type: PageTransitionType.fade);
      default:
        return MaterialPageRoute(builder: (context) => Container());
    }
  }
}
