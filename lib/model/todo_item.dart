class TodoItem {
  String item;
  bool isCompleted;

  TodoItem(this.item, this.isCompleted);

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(json["item"], json["isCompleted"]);
  }

  Map<String, dynamic> toJson() {
    return {"item": item, "isCompleted": isCompleted};
  }

  @override
  String toString() {
    return "$item: $isCompleted";
  }
}
