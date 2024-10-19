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
  late bool isCompleted;
  static const fadeTime = Duration(milliseconds: 500);

  @override
  void initState() {
    isCompleted = widget.isCompleted;
    super.initState();
    controller.fadeIn();
  }

  final controller = FadeInController();

  void onWidgetClicked() async {
    setState(() {
      isCompleted = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    controller.fadeOut();
    await Future.delayed(fadeTime);
    widget.onClick();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      controller: controller,
      duration: fadeTime,
      curve: Curves.linear,
      child: GestureDetector(
        onTap: () => {onWidgetClicked()},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.surfaceContainerLowest,
              leading: checkbox(),
              title: Text(
                widget.todoItem.item,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget checkbox() {
    return Transform.scale(
      scale: 2,
      child: Checkbox(
        value: isCompleted,
        fillColor: WidgetStateColor.resolveWith(
          (_) {
            return Theme.of(context).colorScheme.surface;
          },
        ),
        checkColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(
            width: 1.5,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        onChanged: (_) => {onWidgetClicked()},
      ),
    );
  }
}
