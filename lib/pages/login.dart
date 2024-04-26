import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/routes/routes.dart';
import 'package:todo_app/services/helper_user.dart';
import 'package:todo_app/services/user_service.dart';
import 'package:todo_app/widgets/app_progress_indicator.dart';
import 'package:todo_app/widgets/app_textfield.dart';
import 'package:tuple/tuple.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Text(
                        'Welcome',
                        style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w200,
                            color: Colors.white),
                      ),
                    ),
                    AppTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: usernameController,
                      labelText: 'Please enter email address',
                    ),
                    AppTextField(
                      hideText: true,
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      labelText: 'Please enter your password',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          loginUserInUI(context,
                              email: usernameController.text,
                              password: passwordController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.registerPage);
                      },
                      child: const Text(
                        'Register a new User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        resetPasswordInUI(context,
                            email: usernameController.text);
                      },
                      child: const Text('Reset Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ), ),
                    ),
                  ],
                ),
              ),
            ),
            Selector<UserService, Tuple2>(
              selector: (context, value) =>
                  Tuple2(value.showUserProgress, value.userProgressText),
              builder: (context, value, child) {
                return value.item1
                    ? AppProgressIndicator(text: '${value.item2}')
                    : Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
