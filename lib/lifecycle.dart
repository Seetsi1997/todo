
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/services/user_service.dart';

class LifeCycle extends StatefulWidget {
  const LifeCycle({super.key, required this.child});
  final Widget child;

  @override
 State<LifeCycle> createState() => _LifeCycleState();
}

class _LifeCycleState extends State<LifeCycle> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    UIState check = await getUIStateFlag();
    if (check == UIState.CHANGED &&
        state == AppLifecycleState.inactive &&
        context.read<UserService>().currentUser != null) {
      await context
          .read<TodoService>()
          .saveTodoEntry(context.read<UserService>().currentUser!.email, false);
      setUIStateFlag(UIState.NO_CHANGE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

enum UIState {
  CHANGED,
  NO_CHANGE,
}

void setUIStateFlag(UIState state) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('uistate', state == UIState.CHANGED ? 1 : 0);
}

Future<UIState> getUIStateFlag() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int check = prefs.getInt('uistate') ?? 0;
  return check == 1 ? UIState.CHANGED : UIState.NO_CHANGE;
}
