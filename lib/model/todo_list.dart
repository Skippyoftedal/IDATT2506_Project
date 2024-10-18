import 'dart:convert';
import 'dart:developer';

import 'package:idatt2506_project/model/todo_item.dart';

class TodoList {
  String name;
  List<TodoItem> completed;
  List<TodoItem> inProgress;

  TodoList(this.name, this.completed, this.inProgress);

  factory TodoList.fromJson(Map<String, dynamic> json) {
    var completedJson = (json["completed"] as List)
        .map((item) => TodoItem.fromJson(item))
        .toList();
    var inProgressJson = (json["inProgress"] as List)
        .map((item) => TodoItem.fromJson(item))
        .toList();

    return TodoList(json["name"], completedJson, inProgressJson);
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
    return {"name": name, "completed": completed, "inProgress": inProgress};
  }

  void addTodoItem({required TodoItem item, isCompleted = false}) {
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
    print("old index: $oldIndex, newIndex: $newIndex");
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
