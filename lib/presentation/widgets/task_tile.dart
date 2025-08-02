import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import 'TaskFormWidget.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskBloc>();

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

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskFormWidget(task: task),
          ),
        ),
        onLongPress: () => _confirmDelete(context, task),
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
                      style: GoogleFonts.roboto(
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
                          style: GoogleFonts.roboto(
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
                                task.dueDate!.toLocal().toString().split(' ')[0],
                                style: GoogleFonts.roboto(fontSize: 12),
                              ),
                            ],
                          ),
                        const Spacer(),
                        Chip(
                          label: Text(
                            task.priority.name.toUpperCase(),
                            style: GoogleFonts.roboto(
                              color: getPriorityColor(),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: getPriorityColor().withOpacity(0.15),
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

  void _confirmDelete(BuildContext context, Task task) {
    final bloc = context.read<TaskBloc>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Task', style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
        content: Text('Are you sure you want to delete this task?', style: GoogleFonts.roboto()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.roboto())),
          ElevatedButton(
            onPressed: () {
              bloc.add(DeleteTaskEvent(task));
              Navigator.pop(context);
            },
            child: Text('Delete', style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
