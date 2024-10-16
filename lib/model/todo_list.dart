import 'package:idatt2506_project/model/todo_item.dart';

class TodoList {
  String name;
  List<TodoItem> items;
  DateTime creationTime;

  TodoList(this.name, this.items) : creationTime = DateTime.now();

  factory TodoList.fromJson(Map<String, dynamic> json) {
    var itemList =
        (json["items"] as List).map((item) => TodoItem.fromJson(item)).toList();

    return TodoList(json["name"], itemList);
  }

  @override
  String toString() {
    return "List: '$name' with ${items.length} items: [${items.join(", ")}]";
  }
}
