import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/presentation/pages/task_home_page.dart';

import 'data/task_repository.dart';
import 'models/task.dart';
import 'presentation/bloc/task_bloc.dart';
import 'presentation/bloc/task_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());

  final repository = HiveTaskRepository();
  await repository.init();

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TaskRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskBloc(repository: repository)..add(LoadTasks()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TODO App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
        ),
        home: TaskHomePage(),
      ),
    );
  }
}
