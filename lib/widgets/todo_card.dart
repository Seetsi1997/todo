
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/models/todo.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    super.key,
    required this.todo,
    required this.deleteAction,
    required this.todoToggleAction,
  });
  final Todo todo;
  final Function() deleteAction;
  final Function(bool? value) todoToggleAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade300,
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: 'Delete',
            color: Colors.purple[600],
            icon: Icons.delete,
            onTap: deleteAction,
          ),
        ],
        child: CheckboxListTile(
          checkColor: Colors.purple,
          activeColor: Colors.purple[100],
          value: todo.done,
          onChanged: todoToggleAction,
          subtitle: Text(
            '${todo.created.day}/${todo.created.month}/${todo.created.year}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              color: Colors.white,
              decoration:
                  todo.done ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
