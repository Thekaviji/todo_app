import 'package:bloc/bloc.dart';
import 'package:todo_app/presentation/bloc/task_event.dart';
import 'package:todo_app/presentation/bloc/task_state.dart';
import '../../data/task_repository.dart';
import '../../models/task.dart';


enum TaskFilter { all, active, completed }

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskFilter _filter = TaskFilter.all;
  TaskFilter get filter => _filter;

  TaskBloc({required this.repository}) : super(TaskLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ChangeFilterEvent>(_onChangeFilter);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final tasks = await repository.getTasks();
    final sortedTasks = _sortTasksByDueDate(tasks);
    emit(TaskLoaded(_applyFilter(sortedTasks)));
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    await repository.addTask(event.task);
    add(LoadTasks());
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    await repository.updateTask(event.task);
    add(LoadTasks());
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    await repository.deleteTask(event.task);
    add(LoadTasks());
  }

  Future<void> _onChangeFilter(ChangeFilterEvent event, Emitter<TaskState> emit) async {
    _filter = event.filter;
    final tasks = await repository.getTasks();
    final sortedTasks = _sortTasksByDueDate(tasks);
    emit(TaskLoaded(_applyFilter(sortedTasks)));
  }

  List<Task> _applyFilter(List<Task> tasks) {
    switch (_filter) {
      case TaskFilter.active:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
      return tasks;
    }
  }

  List<Task> _sortTasksByDueDate(List<Task> tasks) {
    var sorted = List<Task>.from(tasks);
    sorted.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return sorted;
  }
}
