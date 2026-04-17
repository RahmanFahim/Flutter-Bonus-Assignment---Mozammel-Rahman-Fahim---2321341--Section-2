import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskRepository {
  // Reference to the "tasks" collection in your Firebase project
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  // TASK 4: Add Task
  Future<void> addTask(TaskModel task) async {
    try {
      // Uses the helper from our model to convert the object to Map
      await _taskCollection.add(task.toFirestore());
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  // TASK 4: Delete Task
  Future<void> deleteTask(String id) async {
    try {
      await _taskCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  // TASK 6: Fetch Tasks Stream (Real-time updates)
  Stream<List<TaskModel>> getTasks() {
    return _taskCollection
        .orderBy('createdAt', descending: true) // Shows newest tasks first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        // Uses the helper from our model to convert Document to Object
        return TaskModel.fromFirestore(doc);
      }).toList();
    });
  }
}