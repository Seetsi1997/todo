
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:todo_app/services/helper_todo.dart';
import 'package:todo_app/services/helper_user.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/services/user_service.dart';
import 'package:todo_app/widgets/app_progress_indicator.dart';
import 'package:todo_app/widgets/todo_card.dart';
import 'package:tuple/tuple.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TextEditingController todoController;

  @override
  void initState() {
    super.initState();
    todoController = TextEditingController();
  }

  @override
  void dispose() {
    todoController.dispose();
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
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            refreshTodosInUI(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () async {
                            saveAllTodosInUI(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text('Create a new TODO'),
                                  content: TextField(
                                    decoration: const InputDecoration(
                                        hintText: 'Please enter TODO'),
                                    controller: todoController,
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Save'),
                                      onPressed: () async {
                                        createNewTodoInUI(context,
                                            titleController: todoController);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            logoutUserInUI(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: provider.Selector<UserService, BackendlessUser?>(
                      selector: (context, value) => value.currentUser,
                      builder: (context, value, child) {
                        return value == null
                            ? Container()
                            : Text(
                                '${value.getProperty('name')}\'s Todo list',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 46,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white,
                                ),
                              );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 20),
                      child: provider.Consumer<TodoService>(
                        builder: (context, value, child) {
                          return ListView.builder(
                            itemCount: value.todos.length,
                            itemBuilder: (context, index) {
                              return TodoCard(
                                todo: value.todos[index],
                                todoToggleAction: (valueStatus) async {
                                  context
                                      .read<TodoService>()
                                      .toggleTodoDone(index);
                                },
                                deleteAction: () async {
                                  context
                                      .read<TodoService>()
                                      .deleteTodo(value.todos[index]);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            provider.Selector<UserService, Tuple2>(
              selector: (context, value) =>
                  Tuple2(value.showUserProgress, value.userProgressText),
              builder: (context, value, child) {
                return value.item1
                    ? AppProgressIndicator(text: value.item2)
                    : Container();
              },
            ),
            provider.Selector<TodoService, Tuple2>(
              selector: (context, value) =>
                  Tuple2(value.busyRetrieving, value.busySaving),
              builder: (context, value, child) {
                return value.item1
                    ? const AppProgressIndicator(
                        text:
                            'Busy retrieving data from the database...please wait...')
                    : value.item2
                        ? const AppProgressIndicator(
                            text:
                                'Busy saving data to the database...please wait...')
                        : Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
