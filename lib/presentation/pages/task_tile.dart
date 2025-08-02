import 'package:flutter/material.dart';
import '../../../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: task.dueDate != null
          ? Text('Due: ${task.dueDate!.toLocal()}'.split(' ')[0])
          : null,
      trailing: Icon(
        task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: task.isCompleted ? Colors.green : null,
      ),
    );
  }
}
