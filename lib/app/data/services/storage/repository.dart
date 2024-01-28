import '../../models/task.dart';
import '../../providers/task/provider.dart';

class TaskRepository {
  TaskProvider taskProvider;

  TaskRepository({required this.taskProvider});

  List<Task> readTask() => taskProvider.readTask();
  void writeTask(List<Task> tasks) => taskProvider.writeTask(tasks);
}
