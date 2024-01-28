// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String title;
  final bool done;
  final String voiceNotePath;

  const Todo({
    required this.title,
    this.voiceNotePath = '',
    this.done = false,
  });

  @override
  List<Object?> get props => [title, done];

  Todo copyWith({
    String? title,
    bool? done,
    String? voiceNotePath,
  }) {
    return Todo(
      title: title ?? this.title,
      done: done ?? this.done,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json['title'],
        done: json['done'],
        voiceNotePath: json['voiceNotePath'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'done': done,
        'voiceNotePath': voiceNotePath,
      };
}
