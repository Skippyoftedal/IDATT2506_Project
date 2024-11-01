import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:idatt2506_project/exceptions/already_exists_error.dart';
import 'package:idatt2506_project/exceptions/empty_input_exception.dart';
import 'package:idatt2506_project/exceptions/only_whitespace_error.dart';
import 'package:idatt2506_project/model/todo_item.dart';

class TodoList {
  /// User given name
  String name;

  /// List of items marked as completed
  ///
  /// Note: can contain duplicates
  List<TodoItem> completed;

  /// List of items that are still in progress
  ///
  /// Note: cannot contain duplicates
  List<TodoItem> inProgress;

  /// Number representing the Id of the icon for [IconData.codePoint]
  int iconCodePoint;

  /// Throws an [EmptyInputError] if [name] is empty.
  /// Throws an [OnlyWhitespaceError] if [name] has only whitespace.
  TodoList(
      {required this.name,
      required this.completed,
      required this.inProgress,
      required this.iconCodePoint}) {
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
        inProgress: inProgressJson,
        iconCodePoint: json["iconCodePoint"]);
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
    return {
      "completed": completed,
      "inProgress": inProgress,
      "iconCodePoint": iconCodePoint
    };
  }

  /// The list has at least one item that has not been completed yet
  bool hasItemInProgress(TodoItem item) {
    try {
      inProgress.firstWhere((it) => it.item == item.item);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// No items have been added to the list
  bool hasNoItems() {
    return completed.isEmpty && inProgress.isEmpty;
  }

  ///Removes
  void deleteIdentical(TodoItem newItem, bool isCompleted) {
    var deleteFrom = isCompleted ? completed : inProgress;
    deleteFrom.removeWhere((it) => it.item == newItem.item);
  }

  /// Add an item to the list
  /// Throws an [AlreadyExistsError] if the item already exists in the
  /// [inProgress] list.
  ///
  /// NOTE: no error is thrown if the list has an identical
  /// entry in the [completed] list
  void addTodoItem({required TodoItem item, isCompleted = false}) {
    if (hasItemInProgress(item)) {
      throw AlreadyExistsError(item.item);
    }

    var list = isCompleted ? completed : inProgress;
    list.add(item);
  }

  /// Changes the completed status of an item, moving it from [completed]
  /// to [inProgress] or vice versa, depending on the current state.
  void changeCompletedStatus(TodoItem item, isCompleted) {
    var listFrom = isCompleted ? completed : inProgress;
    var listTo = isCompleted ? inProgress : completed;

    if (!isCompleted){
      deleteIdentical(item, true);
    }
    listTo.add(item);
    listFrom.remove(item);
  }

  /// Used in the [ReorderableListView] class to reorder the items on drag
  void reorder(int oldIndex, int newIndex, isCompleted) {
    log("old index: $oldIndex, newIndex: $newIndex");
    var list = isCompleted ? completed : inProgress;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
  }

  /// Returns a combined list of [completed] and [inProgress], in that order.
  List<TodoItem> getAll() {
    return [...completed, ...inProgress];
  }

  @override
  String toString() {
    return "List: '$name' with ${getAll().length} items: [${getAll().join(", ")}]";
  }
}
