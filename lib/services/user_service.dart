import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_entry.dart';

class UserService with ChangeNotifier {
  BackendlessUser? _currentUser;
  BackendlessUser? get currentUser => _currentUser;

  void setCurrentUserNull() {
    _currentUser = null;
  }

  bool _userExists = false;
  bool get userExists => _userExists;

  set userExists(bool value) {
    _userExists = value;
    notifyListeners();
  }

  bool _showUserProgress = false;
  bool get showUserProgress => _showUserProgress;

  String _userProgressText = '';
  String get userProgressText => _userProgressText;

  Future<String> resetPassword(String username) async {
    String result = 'OK';
    _showUserProgress = true;
    _userProgressText = 'Busy sending reset instructions...please wait...';
    notifyListeners();
    await Backendless.userService
        .restorePassword(username)
        .onError((error, stackTrace) {
      result = getHumanReadableError(error.toString());
    });
    _showUserProgress = false;
    notifyListeners();
    return result;
  }

  Future<String> loginUser(String username, String password) async {
    String result = 'OK';
    _showUserProgress = true;
    _userProgressText = 'Busy logging you in...please wait...';
    notifyListeners();
    BackendlessUser? user = await Backendless.userService
        .login(username, password, true)
        .onError((error, stackTrace) {
      result = getHumanReadableError(error.toString());
    });
    if (user != null) {
      _currentUser = user;
    }
    _showUserProgress = false;
    notifyListeners();
    return result;
  }

  Future<String> logoutUser() async {
    String result = 'OK';
    _showUserProgress = true;
    _userProgressText = 'Busy signing you out...please wait...';
    notifyListeners();
    await Backendless.userService.logout().onError((error, stackTrace) {
      result = error.toString();
    });
    _showUserProgress = false;
    notifyListeners();
    return result;
  }

  Future<String> checkIfUserLoggedIn() async {
    String result = 'OK';

    bool? validLogin = await Backendless.userService
        .isValidLogin()
        .onError((error, stackTrace) {
      result = error.toString();
    });

    if (validLogin != null && validLogin) {
      String? currentUserObjectId = await Backendless.userService
          .loggedInUser()
          .onError((error, stackTrace) {
        result = error.toString();
      });
      if (currentUserObjectId != null) {
        Map<dynamic, dynamic>? mapOfCurrentUser = await Backendless.data
            .of("Users")
            .findById(currentUserObjectId)
            .onError((error, stackTrace) {
          result = error.toString();
        });
        if (mapOfCurrentUser != null) {
          _currentUser = BackendlessUser.fromJson(mapOfCurrentUser);
          notifyListeners();
        } else {
          result = 'NOT OK';
        }
      } else {
        result = 'NOT OK';
      }
    } else {
      result = 'NOT OK';
    }

    return result;
  }

  void checkIfUserExists(String username) async {
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "email = '$username'";

    await Backendless.data
        .withClass<BackendlessUser>()
        .find(queryBuilder)
        .then((value) {
      if (value == null || value.length == 0) {
        _userExists = false;
        notifyListeners();
      } else {
        _userExists = true;
        notifyListeners();
      }
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  Future<String> createUser(BackendlessUser user) async {
    String result = 'OK';
    _showUserProgress = true;
    _userProgressText = 'Creating a new user...please wait...';
    notifyListeners();
    try {
      await Backendless.userService.register(user);
      TodoEntry emptyEntry = TodoEntry(todos: {}, username: user.email);
      await Backendless.data
          .of('TodoEntry')
          .save(emptyEntry.toJson())
          .onError((error, stackTrace) {
        result = error.toString();
      });
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    _showUserProgress = false;
    notifyListeners();
    return result;
  }
}

String getHumanReadableError(String message) {
  if (message.contains('The email address needs to be validated first.')) {
    return 'Please check your inbox, validate your email address, and try to log in again.';
  }
  if (message.contains('User already exists')) {
    return 'This user already exists in our database. Please create a new user.';
  }
  if (message.contains('Invalid login or password')) {
    return 'Please check your username or password. The combination do not match any entry in our database.';
  }
  if (message
      .contains('User account is locked out due to too many failed logins')) {
    return 'Your account is locked due to too many failed login attempts. Please wait 30 minutes and try again.';
  }
  if (message.contains('Unable to find a user with the specified identity')) {
    return 'Your email address does not exist in our database. Please check for spelling mistakes.';
  }
  if (message.contains(
      'Unable to resolve host "api.backendless.com": No address associated with hostname')) {
    return 'It seems as if you do not have an internet connection. Please connect and try again.';
  }
  return message;
}
