import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/presentation/bloc/task_event.dart';

import 'data/task_repository.dart';
import 'models/task.dart';
import 'presentation/bloc/task_bloc.dart';
import 'presentation/pages/task_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskPriorityAdapter());
  Hive.registerAdapter(TaskAdapter());

  final repository = HiveTaskRepository();
  await repository.init();

  runApp(
    BlocProvider<TaskBloc>(
      create: (_) => TaskBloc(repository: repository)..add(LoadTasks()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EB TODO APP',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const TaskHomePage(),
    );
  }
}
