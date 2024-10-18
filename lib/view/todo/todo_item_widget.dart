import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
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
    controller.fadeIn();
  }

  final controller = FadeInController();

  void onWidgetClicked() async{
    controller.fadeOut();
    await Future.delayed(const Duration(seconds: 1));
    widget.onClick();

  }
  
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      controller: controller,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      child: GestureDetector(
        onTap: () => {
          onWidgetClicked()
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Transform.scale(
                scale: 2,
                child: Checkbox(
                  value: widget.isCompleted,
                  fillColor: WidgetStateColor.resolveWith(
                    (_) {
                      return widget.isCompleted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primary;
                    },
                  ),
                  checkColor: Theme.of(context).colorScheme.surface,
                  shape: const CircleBorder(),
                  side: WidgetStateBorderSide.resolveWith(
                    (states) => BorderSide(
                      width: 1.5,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  onChanged: (_) => {onWidgetClicked()},
                ),
              ),
              Text(
                widget.todoItem.item,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
