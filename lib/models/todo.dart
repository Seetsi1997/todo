Map<dynamic, dynamic> convertTodoListToMap(List<Todo> todos) {
  Map<dynamic, dynamic> map = {};
  for (var i = 0; i < todos.length; i++) {
    map.addAll({'$i': todos[i].toJson()});
  }
  return map;
}

List<Todo> convertMapToTodoList(Map<dynamic, dynamic> map) {
  List<Todo> todos = [];
  for (var i = 0; i < map.length; i++) {
    todos.add(Todo.fromJson(map['$i']));
  }
  return todos;
}

class Todo {
  final String title;
  bool done;
  final DateTime created;

  Todo({
    required this.title,
    this.done = false,
    required this.created,
  });

  Map<String, Object?> toJson() => {
        'title': title,
        'done': done ? 1 : 0,
        'created': created.millisecondsSinceEpoch,
      };

  static Todo fromJson(Map<dynamic, dynamic>? json) => Todo(
        title: json!['title'] as String,
        done: json['done'] == 1 ? true : false,
        created: DateTime.fromMillisecondsSinceEpoch(
            (json['created'] as double).toInt()),
      );

  @override
  bool operator ==(covariant Todo other) {
    return (title.toUpperCase().compareTo(other.title.toUpperCase()) == 0);
  }

  @override
  int get hashCode {
    return title.hashCode;
  }
}
