import 'dart:convert';
import 'dart:io';

import '../model/task.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  static const String FIREBASE_URL =
      'https://taskapp-da5bb-default-rtdb.firebaseio.com/';

  Future<List<Task>> getTask() async {
    final taskList = <Task>[];
    final response = await http.get(FIREBASE_URL + 'tasks.json');
    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonModel = json.decode(response.body) as Map;
        jsonModel.forEach((key, value) {
          var taskModel = Task.fromJson(value);
          taskModel.key = key;
          taskList.add(taskModel);
        });
        return taskList;
      default:
        return Future.error(response.statusCode);
    }
  }

  Future<bool> deleteTask(String key) async {
    final response = await http.delete(FIREBASE_URL + 'tasks/$key.json');
    switch (response.statusCode) {
      case HttpStatus.ok:
        return true;
      default:
        return false;
    }
  }

  Future<bool> undoDeletedTask(Task deletedTask) async {
    final response = await http.post(
      FIREBASE_URL + 'tasks.json',
      body: json.encode(deletedTask),
    );
    switch (response.statusCode) {
      case HttpStatus.ok:
        return true;
      default:
        return false;
    }
  }

  Future<bool> updateTask(Task updateTask) async {
    final response = await http.put(
      FIREBASE_URL + 'tasks/${updateTask.key}.json',
      body: json.encode({
        'task': updateTask.task,
        'description': updateTask.description,
        'done': true
      }),
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return true;
      default:
        return false;
    }
  }

  Future<bool> undoUpdateTask(Task updateTask) async {
    final response = await http.put(
      FIREBASE_URL + 'tasks/${updateTask.key}.json',
      body: json.encode({
        'task': updateTask.task,
        'description': updateTask.description,
        'done': false
      }),
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return true;
      default:
        return false;
    }
  }

  Future<bool> addTask(String task, String description) async {
    final response = await http.post(
      FIREBASE_URL + 'tasks.json',
      body: json
          .encode({'task': task, 'description': description, 'done': false}),
    );
    print(response.statusCode);
    switch (response.statusCode) {
      case HttpStatus.ok:
        return true;
      default:
        return false;
    }
  }
}
