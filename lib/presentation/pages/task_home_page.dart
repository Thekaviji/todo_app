import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/TaskFormWidget.dart';
import '../widgets/task_tile.dart';
class TaskHomePage extends StatelessWidget {
  const TaskHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('MY TASKS', style: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 22)),
        actions: [
          PopupMenuButton<TaskFilter>(
            onSelected: (filter) => bloc.add(ChangeFilterEvent(filter)),
            itemBuilder: (_) => const [
              PopupMenuItem(value: TaskFilter.all, child: Text('All')),
              PopupMenuItem(value: TaskFilter.active, child: Text('Active')),
              PopupMenuItem(value: TaskFilter.completed, child: Text('Completed')),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded && state.tasks.isEmpty) {
            return Center(
              child: Text(
                'No tasks yet.',
                style: GoogleFonts.roboto(fontSize: 16),
              ),
            );
          } else if (state is TaskLoaded) {
            return Scrollbar(
              radius: const Radius.circular(12),
              thickness: 6,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: state.tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => TaskTile(task: state.tasks[i]),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TaskFormWidget()),
        ),
        icon: const Icon(Icons.add),
        label: Text('New Task', style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
