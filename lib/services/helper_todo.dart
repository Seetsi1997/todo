import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/services/user_service.dart';
import 'package:todo_app/widgets/dialogs.dart';

void refreshTodosInUI(BuildContext context) async {
  String result = await context.read<TodoService>().getTodos(
        context.read<UserService>().currentUser!.email,
      );
  if (result != 'OK') {
    showSnackBar(context, result);
  } else {
    showSnackBar(context, 'Data successfully retrieved from the database.');
  }
}

void saveAllTodosInUI(BuildContext context) async {
  String result = await context
      .read<TodoService>()
      .saveTodoEntry(context.read<UserService>().currentUser!.email, true);
  if (result != 'OK') {
    showSnackBar(context, result);
  } else {
    showSnackBar(context, 'Data successfully saved online!');
  }
}

void createNewTodoInUI(BuildContext context,
    {required TextEditingController titleController}) async {
  if (titleController.text.isEmpty) {
    showSnackBar(context, 'Please enter a todo first, then save!');
  } else {
    Todo todo = Todo(
      title: titleController.text.trim(),
      created: DateTime.now(),
    );
    if (context.read<TodoService>().todos.contains(todo)) {
      showSnackBar(context, 'Duplicate value. Please try again.');
    } else {
      titleController.text = '';
      context.read<TodoService>().createTodo(todo);
      Navigator.pop(context);
    }
  }
}
