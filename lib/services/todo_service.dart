import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/lifecycle.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/todo_entry.dart';

class TodoService with ChangeNotifier {
  TodoEntry? _todoEntry;

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  void emptyTodos() {
    _todos = [];
    notifyListeners();
  }

  bool _busyRetrieving = false;
  bool _busySaving = false;

  bool get busyRetrieving => _busyRetrieving;
  bool get busySaving => _busySaving;

  Future<String> getTodos(String username) async {
    String result = 'OK';
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "username = '$username'";

    _busyRetrieving = true;
    notifyListeners();

    List<Map<dynamic, dynamic>?>? map = await Backendless.data
        .of('TodoEntry')
        .find(queryBuilder)
        .onError((error, stackTrace) {
      result = error.toString();
    });

    if (result != 'OK') {
      _busyRetrieving = false;
      notifyListeners();
      return result;
    }

    if (map != null) {
      if (map.length > 0) {
        _todoEntry = TodoEntry.fromJson(map.first);
        _todos = convertMapToTodoList(_todoEntry!.todos);
        notifyListeners();
      } else {
        emptyTodos();
      }
    } else {
      result = 'NOT OK';
    }

    _busyRetrieving = false;
    notifyListeners();

    return result;
  }

  Future<String> saveTodoEntry(String username, bool inUI) async {
    String result = 'OK';
    if (_todoEntry == null) {
      _todoEntry =
          TodoEntry(todos: convertTodoListToMap(_todos), username: username);
    } else {
      _todoEntry!.todos = convertTodoListToMap(_todos);
    }

    if (inUI) {
      _busySaving = true;
      notifyListeners();
    }
    await Backendless.data
        .of('TodoEntry')
        .save(_todoEntry!.toJson())
        .onError((error, stackTrace) {
      result = error.toString();
    });
    if (inUI) {
      _busySaving = false;
      notifyListeners();
    }

    return result;
  }

  void toggleTodoDone(int index) {
    _todos[index].done = !_todos[index].done;
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }

  void deleteTodo(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }

  void createTodo(Todo todo) {
    _todos.insert(0, todo);
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }
}
