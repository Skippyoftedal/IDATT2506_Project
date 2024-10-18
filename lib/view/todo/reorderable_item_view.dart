import 'dart:developer';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:idatt2506_project/model/todo_item.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/view/todo/todo_item_widget.dart';

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
    confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
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
      child: explosiveConfettiWidget(
        child: Column(
          children: [
            asScrollableList(widget.todoList.inProgress, false),
            if (widget.todoList.completed.isNotEmpty) const Text("Finished"),
            asScrollableList(widget.todoList.completed, true),
          ],
        ),
      ),
    );
  }

  Widget explosiveConfettiWidget({child}) {
    return ConfettiWidget(
        numberOfParticles: 100,
        maxBlastForce: 50,
        minBlastForce: 1,
        gravity: 0,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        confettiController: confettiController,
        child: child);
  }

  ReorderableListView asScrollableList(Iterable<TodoItem> items, isCompleted) {
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
        ...getFromCompletedStatus(items, isCompleted),
      ],
    );
  }

  List<TodoItemWidget> getFromCompletedStatus(items, isCompleted) {
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
