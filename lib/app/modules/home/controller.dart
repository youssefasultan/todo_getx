import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todo_getx/app/data/models/todo.dart';

import '../../data/models/task.dart';
import '../../data/services/storage/repository.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;

  HomeController({required this.taskRepository});

  final formKey = GlobalKey<FormState>();

  final editController = TextEditingController();

  final chipIndex = 0.obs;
  final tabIndex = 0.obs;
  final tasks = <Task>[].obs;
  final deleting = false.obs;
  final task = Rx<Task?>(null);
  final doingTodos = <Todo>[].obs;
  final doneTodos = <Todo>[].obs;

  final pathToAudio = ''.obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTask());
    ever(tasks, (callback) => taskRepository.writeTask(tasks));
  }

  @override
  void onClose() {
    editController.dispose();
    super.onClose();
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void changeTask(Task? selectedTask) {
    task.value = selectedTask;
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void changePath(String path) {
    pathToAudio.value = path;
  }

  void changeTodos(List<Todo> select) {
    doingTodos.clear();
    doneTodos.clear();

    for (int i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo.done;
      if (status) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  updateTask(Task task, String title, String path) {
    var todos = task.todos;
    if (containTodo(todos, title)) {
      return false;
    }

    todos.add(Todo(title: title, voiceNotePath: path));
    var newTask = task.copyWith(todos: todos);
    int oldIndex = tasks.indexOf(task);
    tasks[oldIndex] = newTask;
    tasks.refresh();
    return true;
  }

  bool containTodo(List<Todo> todos, String title) {
    return todos.any((element) => element.title == title);
  }

  bool addTodo(String text, String path) {
    final doingTodoItem = Todo(title: text, voiceNotePath: path);

    if (doingTodos.contains(doingTodoItem)) {
      return false;
    }

    final doneTodoItem = Todo(title: text, voiceNotePath: path, done: true);
    if (doneTodos.contains(doneTodoItem)) {
      return false;
    }

    doingTodos.add(doingTodoItem);
    doingTodos.refresh();
    return true;
  }

  void updateTodos() {
    var newTodos = <Todo>[];
    newTodos.addAll([...doingTodos, ...doneTodos]);

    var newTask = task.value!.copyWith(todos: newTodos);

    int oldIndex = tasks.indexOf(task.value);
    tasks[oldIndex] = newTask;

    tasks.refresh();
  }

  void doneToDo(String title) {
    final doingTodoItem = Todo(title: title);
    int index = doingTodos.indexWhere((element) => element == doingTodoItem);

    doingTodos.removeAt(index);

    doneTodos.add(doingTodoItem.copyWith(done: true));

    doingTodos.refresh();
    doneTodos.refresh();
  }

  void deleteDoneTodo(Todo doneTodo) {
    int index = doneTodos.indexWhere((element) => element == doneTodo);

    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  bool isTodoEmpty(Task task) {
    return task.todos.isEmpty;
  }

  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos.length; i++) {
      if (task.todos[i].done) {
        res++;
      }
    }

    return res;
  }

  int getTotalTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      res += tasks[i].todos.length;
    }

    return res;
  }

  int totalDoneTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      for (int j = 0; j < tasks[i].todos.length; j++) {
        if (tasks[i].todos[j].done) {
          res++;
        }
      }
    }

    return res;
  }
}
