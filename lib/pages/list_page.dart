import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:idatt2506_project/services/list_service.dart';
import 'package:idatt2506_project/model/todo_item.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/view/navigation/standard_scaffold.dart';
import 'package:idatt2506_project/view/todo/reorderable_item_view.dart';

class ListPage extends StatefulWidget {
  final String fileName;

  const ListPage({super.key, required this.fileName});

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
      title: todoList?.name,
      body: todoList == null
          ? Text(errorMessage)
          : Column(
              children: [
                if (todoList?.isTotallyEmpty() ?? false)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const Text(
                      "The list is empty! Add some items by typing in the textbox 😉",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                  ),
                if (todoList != null)
                  Expanded(
                    child: Container(
                      height: 200,
                      color: Theme.of(context).colorScheme.surface,
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
                        decoration: InputDecoration(
                            enabledBorder: getBorder(),
                            focusedBorder: getBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                addTodoListItem(textController.text);
                                textController.text = "";
                              },
                              icon: Icon(Icons.send,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            hintText: "Add a new item to the list"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  OutlineInputBorder getBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary, width: 2.0),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)));
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
      //TODO delete before submission, is
      //TODO not necessary when the lists already exist
      TodoList? fetched;
      for (var i = 0; i < 10; i++) {
        try {
          await Future.delayed(const Duration(milliseconds: 100));
          fetched = await ListService.getList(context, widget.fileName);

          if (fetched != null) {
            break;
          }
        } catch (e) {
          if (i == 9) {
            rethrow;
          }
        }
      }
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
