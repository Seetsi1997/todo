import 'package:flutter/material.dart';
import 'package:todo_app/pages/loading.dart';
import 'package:todo_app/pages/login.dart';
import 'package:todo_app/pages/register.dart';
import 'package:todo_app/pages/todo_page.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registerPage = '/registerPage';
  static const String todoPage = '/todoPage';
  static const String loadingPage = '/loadingPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => const Register(),
        );

      case todoPage:
        return MaterialPageRoute(
          builder: (context) => const TodoPage(),
        );

      case loadingPage:
        return MaterialPageRoute(
          builder: (context) => const Loading(),
        );

      default:
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}
