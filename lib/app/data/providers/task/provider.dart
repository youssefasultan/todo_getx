import 'dart:convert';

import 'package:get/get.dart';
import 'package:todo_getx/app/core/utils/keys.dart';

import '../../models/task.dart';
import '../../services/storage/services.dart';

class TaskProvider {
  final StorageService _storage = Get.find<StorageService>();
  List<Task> readTask() {
    var taskList = <Task>[];
    jsonDecode(_storage.read(taskKey).toString())
        .forEach((e) => taskList.add(Task.fromJson(e)));

    return taskList;
  }

  void writeTask(List<Task> tasks) {
    _storage.write(taskKey, jsonEncode(tasks));
  }
}
