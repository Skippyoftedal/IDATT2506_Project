import 'dart:developer';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:idatt2506_project/model/todo_item.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/view/todo/explosive_confetti_widget.dart';
import 'package:idatt2506_project/view/todo/todo_item_widget.dart';
import'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemView extends StatefulWidget {
  const ItemView(
      {super.key, required this.todoList, required this.onUpdateList});

  final TodoList todoList;
  final Function() onUpdateList;

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  late ConfettiController confettiController;
  late bool listHasBeenFinished;

  @override
  void initState() {
    super.initState();
    listHasBeenFinished = widget.todoList.inProgress.isEmpty;
    confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  void updateList() {
    if (!listHasBeenFinished && widget.todoList.inProgress.isEmpty) {
      listHasBeenFinished = true;
      confettiController.play();
    }
    widget.onUpdateList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExplosiveConfettiWidget(
        confettiController: confettiController,
        child: Column(
          children: [
            reorderableList(widget.todoList.inProgress, false),
            if (widget.todoList.inProgress.isNotEmpty && widget.todoList.inProgress.isNotEmpty)
              Text(AppLocalizations.of(context)!.finished),
            reorderableList(widget.todoList.completed, true),
          ],
        ),
      ),
    );
  }


  ReorderableListView reorderableList(Iterable<TodoItem> items, isCompleted) {
    return ReorderableListView(
      reverse: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          widget.todoList.reorder(oldIndex, newIndex, isCompleted);
          updateList();
        });
      },
      proxyDecorator: (child, index, animation) => Material(
        borderRadius: BorderRadius.circular(10),
        shadowColor: Colors.black,
        elevation: 5,
        child: child,
      ),
      children: [
        ..._getTodoWidgetsFromCompletedStatus(items, isCompleted),
      ],
    );
  }

  List<TodoItemWidget> _getTodoWidgetsFromCompletedStatus(items, isCompleted) {
    return [
      for (var listItem in items)
        TodoItemWidget(
          key: ValueKey(listItem),
          todoItem: listItem,
          isCompleted: isCompleted,
          onClick: () {
            setState(() {
              widget.todoList.changeCompletedStatus(listItem, isCompleted);
            });
            log("The listitem has been clicked");
            updateList();
          },
        ),
    ];
  }
}


class ScrollableList extends StatelessWidget {
  const ScrollableList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}




