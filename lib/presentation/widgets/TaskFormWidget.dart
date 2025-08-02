import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

class TaskFormWidget extends StatefulWidget {
  final Task? task;
  final void Function()? onSaved;

  const TaskFormWidget({super.key, this.task, this.onSaved});

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  late TaskPriority priority;
  DateTime? dueDate;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.task?.title ?? '');
    descCtrl = TextEditingController(text: widget.task?.description ?? '');
    priority = widget.task?.priority ?? TaskPriority.medium;
    dueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskBloc>();

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shrinkWrap: true,
        children: [
          Text(
            widget.task == null ? 'Create New Task' : 'Update Task',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),

          TextFormField(
            controller: titleCtrl,
            decoration: InputDecoration(
              labelText: 'Title',
              prefixIcon: const Icon(Icons.edit_note_rounded),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            style: const TextStyle(fontSize: 16),
            validator: (v) => v!.trim().isEmpty ? 'Please enter title' : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: descCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
              prefixIcon: const Icon(Icons.description_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<TaskPriority>(
            value: priority,
            decoration: InputDecoration(
              labelText: 'Priority',
              prefixIcon: const Icon(Icons.flag_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            items: TaskPriority.values.map((p) {
              return DropdownMenuItem(
                value: p,
                child: Text(
                  p.name[0].toUpperCase() + p.name.substring(1),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }).toList(),
            onChanged: (val) => setState(() => priority = val!),
          ),
          const SizedBox(height: 16),

          Text(
            'Due Date',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              if (dueDate != null)
                Chip(
                  label: Text(
                    '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  avatar: const Icon(Icons.calendar_today, color: Colors.white),
                ),

              if (dueDate != null) const SizedBox(width: 8),

              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_calendar_outlined),
                  label: const Text("Pick Date"),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Theme.of(context).colorScheme.primary,
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() => dueDate = picked);
                    }
                  },
                ),
              ),

              if (dueDate != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear Date',
                  onPressed: () => setState(() => dueDate = null),
                ),
            ],
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: Text(widget.task == null ? 'Save Task' : 'Update Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                final newTask = (widget.task ?? Task(title: titleCtrl.text.trim())).copyWith(
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                  priority: priority,
                  dueDate: dueDate,
                );

                if (widget.task == null) {
                  bloc.add(AddTaskEvent(newTask));
                } else {
                  bloc.add(UpdateTaskEvent(newTask));
                }

                if (widget.onSaved != null) widget.onSaved!();
              },
            ),
          )
        ],
      ),
    );
  }
}
