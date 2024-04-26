
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/routes/routes.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/services/user_service.dart';

class InitApp {
  static final String apiKeyAndroid = 'E76C29DC-0E70-4B07-A086-78AF89F4C8F5';
  static final String apiKeyiOS = '9C2C0A42-FD97-4CE5-B311-34E21E934BFD';
  static final String appID = 'E6E8D8A1-7CA5-79EB-FFF1-E76FEB3AA100';

  static void initializeApp(BuildContext context) async {
    await Backendless.initApp(
        applicationId: appID,
        iosApiKey: apiKeyiOS,
        androidApiKey: apiKeyAndroid);
    String result = await context.read<UserService>().checkIfUserLoggedIn();
    if (result == 'OK') {
      context
          .read<TodoService>()
          .getTodos(context.read<UserService>().currentUser!.email);
      Navigator.popAndPushNamed(context, RouteManager.todoPage);
    } else {
      Navigator.popAndPushNamed(context, RouteManager.loginPage);
    }
  }
}
