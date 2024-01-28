import 'package:equatable/equatable.dart';
import 'package:todo_getx/app/data/models/todo.dart';

class Task extends Equatable {
  final String title;
  final int icon;
  final String color;
  final List<Todo> todos;

  const Task({
    required this.title,
    required this.icon,
    required this.color,
    required this.todos,
  });

  Task copyWith({
    String? title,
    int? icon,
    String? color,
    List<Todo>? todos,
  }) =>
      Task(
        title: title ?? this.title,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        todos: todos ?? this.todos,
      );

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        icon: json['icon'],
        color: json['color'],
        todos: json['todos'] != null
            ? (json['todos'] as List<dynamic>)
                .map((e) => Todo.fromJson(e))
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'icon': icon,
        'color': color,
        'todos': todos,
      };

  @override
  List<Object?> get props => [title, icon, color];
}
