import 'dart:convert';

import 'package:idatt2506_project/model/todo_item.dart';

class TodoList {
  String name;
  List<TodoItem> items;

  TodoList(this.name, this.items);


  factory TodoList.fromJson(Map<String, dynamic> json) {
    var itemList =
    (json["items"] as List).map((item) => TodoItem.fromJson(item)).toList();

    return TodoList(json["name"], itemList);
  }

  factory TodoList.fromJsonString(String json) {
    return TodoList.fromJson(jsonDecode(json));
  }



  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "items": items
    };
  }

  void addTodoItem(TodoItem item) {
    items.add(item);
  }

  @override
  String toString() {
    return "List: '$name' with ${items.length} items: [${items.join(", ")}]";
  }
}
