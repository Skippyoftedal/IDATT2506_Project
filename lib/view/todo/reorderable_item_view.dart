import 'dart:developer';
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
  void updateList() {
    widget.onUpdateList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          asScrollableList(widget.todoList.inProgress, false),
          asScrollableList(widget.todoList.completed, true),
        ],
      ),
    );
  }

  ReorderableListView asScrollableList(List<TodoItem> items, isCompleted) {
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          widget.todoList.reorder(oldIndex, newIndex, isCompleted); //fix this
          updateList();
        });
      },
      proxyDecorator: (child, index, animation) =>
          Material(
            borderRadius: BorderRadius.circular(10),
            shadowColor: Colors.black,
            elevation: 5,
            child: child,
          ),
      children: [
        ...getFromCompletedStatus(isCompleted),
      ],
    );
  }

  List<TodoItemWidget> getFromCompletedStatus(bool isCompleted) {
    var list =
    isCompleted ? widget.todoList.completed : widget.todoList.inProgress;
    return [
      for (var listItem in list)
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
