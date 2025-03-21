import 'package:flutter/material.dart';
import 'package:ngoc_base_flutter/util/routes.dart';

import '../ui/widget/widget.dart';
import 'localizations.dart';

class NavigationService {
  NavigationService._internal();

  static final NavigationService instance = NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  pushReplacement(String routeName) {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  popToRootView() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  pop() {
    navigatorKey.currentState?.pop();
  }

  popWithParam(param) {
    navigatorKey.currentState?.pop(param);
  }

  showDialogTokenExpired() {
    BuildContext? context = navigatorKey.currentState?.overlay?.context;
    if (context == null) {
      return;
    }
    String? message = Language.of(context)?.getText.call("token_expired_message") ?? "";
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        content: message,
        onSubmit: () {
          pushReplacement(Routes.loginScreen);
        },
      ),
    );
  }
}
