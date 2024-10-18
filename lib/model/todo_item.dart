import 'dart:developer';

class TodoItem {
  String item;

  TodoItem(this.item);

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    try {
      return TodoItem(json["item"]);
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
}
