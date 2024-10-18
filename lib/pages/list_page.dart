import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:idatt2506_project/services/list_service.dart';
import 'package:idatt2506_project/model/todo_item.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/view/navigation/standard_scaffold.dart';
import 'package:idatt2506_project/view/todo/reorderable_item_view.dart';


class ListPage extends StatefulWidget {
  final String listName;

  const ListPage({super.key, required this.listName});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TodoList? todoList;
  String errorMessage = "";
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StandardScaffold(
      body: todoList == null
          ? Text(errorMessage)
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(todoList!.name,
                        style: Theme.of(context).textTheme.headlineLarge),
                  ],
                ),
                if (todoList != null)
                  Expanded(
                    child: Container(
                      height: 200,
                      color: Colors.limeAccent,
                      child: ItemView(
                          todoList: todoList!, onUpdateList: updateList),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        onSubmitted: (submission) {
                          textController.text = "";
                          addTodoListItem(submission);
                        },
                        onEditingComplete: () {},
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Add a new item to the list"),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          addTodoListItem(textController.text);
                          textController.text = "";
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
              ],
            ),
    );
  }



  void addTodoListItem(String text) {
    setState(() {
      todoList?.addTodoItem(item: TodoItem(text), isCompleted: false);
    });
    updateList();
  }

  void updateList() {
    log("Updating list");
    if (todoList != null) {
      ListService.saveList(context, todoList!);
    }
  }

  void fetchList() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final fetched = await ListService.getList(context, widget.listName);
      log("fetched list $fetched");
      setState(() {
        todoList = fetched;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    fetchList();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
