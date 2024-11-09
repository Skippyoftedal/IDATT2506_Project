import 'dart:developer';

import 'package:idatt2506_project/error/empty_input_error.dart';
import 'package:idatt2506_project/error/only_whitespace_error.dart';
import 'package:idatt2506_project/model/todo_list.dart';



/// Item in a [TodoList]
class TodoItem {
  String item;

  /// Creates a [TodoItem]
  ///
  /// Throws an [EmptyInputError] if [item] is empty.
  /// Throws an [OnlyWhitespaceError] if [item] has only whitespace.
  TodoItem(this.item){
    if (item.isEmpty){
      throw EmptyInputError("Todo item name cannot be empty");
    }
    if (item.trim().isEmpty){
      throw OnlyWhitespaceError("Todo item name cannot consist of only whitespace");
    }
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    try {
      return TodoItem(json["item"] as String);
    } catch (e) {

      log("json parsing error for todoItem :$e");
      throw StateError("Cannot parse $json");
    }
  }

  Map<String, dynamic> toJson() {
    return {"item": item};
  }

  @override
  String toString() {
    return item;
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoItem &&
          runtimeType == other.runtimeType &&
          item == other.item;

  @override
  int get hashCode => item.hashCode;

}
