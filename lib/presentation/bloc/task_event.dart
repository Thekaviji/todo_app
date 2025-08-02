import 'package:equatable/equatable.dart';
import 'package:todo_app/presentation/bloc/task_bloc.dart';

import '../../models/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final Task task;
  const DeleteTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class ChangeFilterEvent extends TaskEvent {
  final TaskFilter filter;
  const ChangeFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
