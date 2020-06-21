import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'package:todoey/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskData extends ChangeNotifier {
  TaskData() {
    initDB();
  }

  var _prefs;

  void initDB() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool('firstRun') ?? true) {
      _prefs.setString('3', 'Tap (+) to add new Task');
      _prefs.setBool('3done', false);
      _prefs.setString('2', 'Tap on checkbox to mark task as Done');
      _prefs.setBool('2done', false);
      _prefs.setString('1', 'Tap and hold on task\'s name to delete task');
      _prefs.setBool('1done', false);
      _prefs.setBool('firstRun', false);
    }
    reloadTaskList();
  }

  List<Task> _tasks = [];

  UnmodifiableListView get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void reloadTaskList() {
    _tasks = [];
    var tasks = _prefs.getKeys().toList();
    for (var task in tasks) {
      if (_prefs.get(task) is String) {
        _tasks.add(Task(
            key: int.parse(task),
            name: _prefs.getString(task),
            isDone: _prefs.getBool('${task}done')));
      }
    }
    _tasks..sort((b, a) => a.key.compareTo(b.key));
    notifyListeners();
  }

  void addNewTask(String newTaskName) {
    if (_tasks.isNotEmpty) {
      _prefs.setString('${_tasks.first.key + 1}', newTaskName);
      _prefs.setBool('${_tasks.first.key + 1}done', false);
    } else {
      _prefs.setString('1', newTaskName);
      _prefs.setBool('1done', false);
    }

    reloadTaskList();
  }

  void updateTask(Task task) {
    if (_prefs.getBool('${task.key}done')) {
      _prefs.setBool('${task.key}done', false);
    } else {
      _prefs.setBool('${task.key}done', true);
    }
    reloadTaskList();
  }

  void deleteTask(Task task) {
    _prefs.remove('${task.key}done');
    _prefs.remove('${task.key}');
    reloadTaskList();
  }
}
