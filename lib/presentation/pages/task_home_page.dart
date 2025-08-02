import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/pages/task_tile.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_state.dart';

class TaskHomePage extends StatelessWidget {
  const TaskHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final tasks = state.tasks;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, index) => TaskTile(task: tasks[index]),
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // later: showTaskForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
