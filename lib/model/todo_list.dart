import 'dart:convert';
import 'dart:developer';

import 'package:idatt2506_project/exceptions/already_exists_error.dart';
import 'package:idatt2506_project/exceptions/empty_input_exception.dart';
import 'package:idatt2506_project/exceptions/only_whitespace_error.dart';
import 'package:idatt2506_project/model/todo_item.dart';

class TodoList {
  String name;
  List<TodoItem> completed;
  List<TodoItem> inProgress;
  int? iconCodePoint;

  TodoList(
      {required this.name,
      required this.completed,
      required this.inProgress,
      this.iconCodePoint}) {
    if (name.isEmpty) {
      throw EmptyInputError("An empty list name was provided");
    }
    if (name.trim().isEmpty) {
      throw OnlyWhitespaceError(
          "A list name with only whitespace was provided");
    }
  }

  factory TodoList.fromJson(Map<String, dynamic> json) {
    var completedJson = (json["completed"] as List)
        .map((item) => TodoItem.fromJson(item))
        .toList();
    var inProgressJson = (json["inProgress"] as List)
        .map((item) => TodoItem.fromJson(item))
        .toList();

    return TodoList(
        name: "Name has not been updated",
        completed: completedJson,
        inProgress: inProgressJson);
  }

  factory TodoList.fromJsonString(String json) {
    try {
      return TodoList.fromJson(jsonDecode(json));
    } catch (e) {
      log("json parsing error for todolist: $e");
      throw StateError("Cannot parse $json");
    }
  }

  Map<String, dynamic> toJson() {
    return {"completed": completed, "inProgress": inProgress};
  }

  bool hasItemInProgress(TodoItem item) {
    try {
      inProgress.firstWhere((it) => it.item == item.item);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool hasNoItems() {
    return completed.isEmpty && inProgress.isEmpty;
  }

  void addTodoItem({required TodoItem item, isCompleted = false}) {
    if (hasItemInProgress(item)) {
      throw AlreadyExistsError(item.item);
    }

    var list = isCompleted ? completed : inProgress;
    list.add(item);
  }

  void changeCompletedStatus(TodoItem item, isIsCompletedCurrently) {
    var listFrom = isIsCompletedCurrently ? completed : inProgress;
    var listTo = isIsCompletedCurrently ? inProgress : completed;
    listFrom.remove(item);
    listTo.add(item);
  }

  void reorder(int oldIndex, int newIndex, isCompleted) {
    log("old index: $oldIndex, newIndex: $newIndex");
    var list = isCompleted ? completed : inProgress;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
  }

  List<TodoItem> getAll() {
    return [...completed, ...inProgress];
  }

  @override
  String toString() {
    return "List: '$name' with ${getAll().length} items: [${getAll().join(", ")}]";
  }
}
