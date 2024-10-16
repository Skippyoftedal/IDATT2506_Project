import 'package:flutter/material.dart';

import 'model/todo_item.dart';

class TodoItemWidget extends StatefulWidget {
  final TodoItem todoItem;

  const TodoItemWidget(this.todoItem, {super.key});

  @override
  TodoItemWidgetState createState() => TodoItemWidgetState();
}

class TodoItemWidgetState extends State<TodoItemWidget> {

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Transform.scale(
            scale: 3,
            child: Checkbox(
                value: isChecked,
                onChanged: (newState){
                  setState(() {
                    isChecked = newState ?? false;
                  });
                }),
          ),

          Text(widget.todoItem.item),
        ],
      ),
    );
  }
}


