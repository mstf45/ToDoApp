import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:todoapp/feature/home/home/model/todo.dart';

@immutable
final class HomeState extends Equatable {
  const HomeState({
    this.todos = const [],
    this.unsyncedIds = const [],
    this.isLoading = true,
    this.feedbackMessage = '',
    this.feedbackTick = 0,
    this.feedbackIsError = false,
  });

  final List<Todo> todos;
  final List<String> unsyncedIds;
  final bool isLoading;
  final String feedbackMessage;
  final int feedbackTick;
  final bool feedbackIsError;

  int get totalCount => todos.length;

  List<Todo> get unsyncedTodos {
    final pending = unsyncedIds.toSet();
    return [for (final todo in todos) if (pending.contains(todo.id)) todo];
  }

  List<Todo> get backedUpTodos {
    final pending = unsyncedIds.toSet();
    return [for (final todo in todos) if (!pending.contains(todo.id)) todo];
  }

  int get completedCount => todos.where((todo) => todo.isCompleted).length;

  int get pendingCount => totalCount - completedCount;

  bool get showStats => !isLoading && todos.isNotEmpty;

  HomeState copyWith({
    List<Todo>? todos,
    List<String>? unsyncedIds,
    bool? isLoading,
    String? feedbackMessage,
    int? feedbackTick,
    bool? feedbackIsError,
  }) {
    return HomeState(
      todos: todos ?? this.todos,
      unsyncedIds: unsyncedIds ?? this.unsyncedIds,
      isLoading: isLoading ?? this.isLoading,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
      feedbackTick: feedbackTick ?? this.feedbackTick,
      feedbackIsError: feedbackIsError ?? this.feedbackIsError,
    );
  }

  @override
  List<Object?> get props => [todos, unsyncedIds, isLoading, feedbackMessage, feedbackTick, feedbackIsError];
}
