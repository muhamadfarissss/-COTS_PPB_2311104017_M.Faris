import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskController extends ChangeNotifier {
  final TaskService _service = TaskService();
  
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // Getter untuk Dashboard [cite: 13, 14]
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isDone).length;

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _tasks = await _service.getTasks();
    } catch (e) {
      debugPrint("Error fetching tasks: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    await _service.addTask(task);
    await fetchTasks();
  }

  // Logika toggle selesai sesuai API 3B dan 3C [cite: 190-209]
  Future<void> toggleTaskStatus(int id, bool isNowDone) async {
    String newStatus = isNowDone ? "SELESAI" : "BERJALAN";
    await _service.updateTask(id, {
      'is_done': isNowDone,
      'status': newStatus
    });
    await fetchTasks();
  }

  // Logika update catatan saja sesuai API 3A [cite: 182-189]
  Future<void> updateTaskNote(int id, String newNote) async {
    await _service.updateTask(id, {'note': newNote});
    await fetchTasks();
  }
}