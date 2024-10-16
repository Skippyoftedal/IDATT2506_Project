class TodoItem {
  String item;
  TodoItem(this.item);

  factory TodoItem.fromJson(Map<String, dynamic> json){
    return TodoItem(
      json["item"]
    );
  }

  @override
  String toString() {
    return item;
  }
}