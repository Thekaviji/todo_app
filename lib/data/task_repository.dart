import 'package:hive/hive.dart';
import '../models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(Task task);
}

class HiveTaskRepository implements TaskRepository {
  static const _boxName = 'tasks';
  late Box<Task> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Task>(_boxName);
  }

  @override
  Future<List<Task>> getTasks() async {
    return _box.values.toList();
  }

  @override
  Future<void> addTask(Task task) async {
    await _box.put(task.id, task); // ✅ Store with custom ID as key!
  }

  @override
  Future<void> updateTask(Task task) async {
    await _box.put(task.id, task); // ✅ Replaces based on ID
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _box.delete(task.id); // ✅ Deletes by ID
  }
}
