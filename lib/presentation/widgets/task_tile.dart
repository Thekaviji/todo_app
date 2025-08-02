import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import 'TaskFormWidget.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  Color getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskBloc>();

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<TaskBloc>(context),
                child: Scaffold(
                  appBar: AppBar(title: const Text('Edit Task')),
                  body: TaskFormWidget(
                    task: task,
                    onSaved: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          );
        },
        onLongPress: () => _confirmDelete(context, bloc),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (val) {
                  final updated = task.copyWith(isCompleted: val ?? false);
                  bloc.add(UpdateTaskEvent(updated));
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.description?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          task.description!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (task.dueDate != null)
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${task.dueDate!.toLocal()}'.split(' ')[0],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        const Spacer(),
                        Chip(
                          label: Text(task.priority.name.toUpperCase()),
                          backgroundColor: getPriorityColor().withOpacity(0.15),
                          labelStyle: TextStyle(
                            color: getPriorityColor(),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TaskBloc bloc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              bloc.add(DeleteTaskEvent(task));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
