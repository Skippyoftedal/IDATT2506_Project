import 'package:flutter/material.dart';
import 'package:idatt2506_project/model/todo_item.dart';


class TodoItemWidget extends StatefulWidget {
  final TodoItem todoItem;
  final Function() onClick;
  final bool isCompleted;

  const TodoItemWidget(
      {super.key,
      required this.todoItem,
      required this.isCompleted,
      required this.onClick});

  @override
  State<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {widget.onClick()},
      child: Container(
        padding: const EdgeInsets.all(10),
        //margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Transform.scale(
              scale: 2,
              child: Checkbox(
                value: widget.isCompleted,
                fillColor: WidgetStateColor.resolveWith(
                  (_) {
                    return widget.isCompleted
                        ? Colors.white
                        : Colors.red;
                  },
                ),
                checkColor: Colors.black,
                shape: const CircleBorder(),
                onChanged: (_) => {widget.onClick()},
              ),
            ),
            Text(
              widget.todoItem.item,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
