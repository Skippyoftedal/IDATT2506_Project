import 'dart:developer';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:idatt2506_project/exceptions/already_exists_error.dart';
import 'package:idatt2506_project/exceptions/empty_input_exception.dart';
import 'package:idatt2506_project/exceptions/only_whitespace_error.dart';
import 'package:idatt2506_project/services/list_service.dart';
import 'package:idatt2506_project/model/todo_item.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/view/error/critical_error.dart';
import 'package:idatt2506_project/view/navigation/standard_scaffold.dart';
import 'package:idatt2506_project/view/todo/reorderable_item_view.dart';
import'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      title: todoList?.name,
      body: todoList == null
          ? Text(errorMessage)
          : Column(
              children: [
                if (todoList?.hasNoItems() ?? false)
                  Container(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      child: listIsEmptyMessage()),
                if (todoList != null)
                  Expanded(
                    child: Container(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
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
                            hintText: AppLocalizations.of(context)!.addNewItemToList),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget listIsEmptyMessage() {
    return BubbleSpecialThree(
      text: AppLocalizations.of(context)!.emptyListMessageHint,
      color: Theme.of(context).colorScheme.tertiary,
      textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onTertiary, fontSize: 18),
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
    String? errorMessage;
    setState(() {
      try {
        todoList?.addTodoItem(item: TodoItem(text), isCompleted: false);
        updateList();
      } on AlreadyExistsError catch (e){
        errorMessage = AppLocalizations.of(context)?.itemAlreadyExits(e.toString());
      } on OnlyWhitespaceError catch (_){
        errorMessage = AppLocalizations.of(context)?.whitespaceItemError;
      } on EmptyInputError catch (_){
        errorMessage = AppLocalizations.of(context)?.emptyItemError;
      } catch (e){
        errorMessage = e.toString();
        log(e.toString());
      }
    });

    if (errorMessage != null) {
      CriticalError(errorMessage: errorMessage!).show(context);
    }

  }

  void updateList() {
    log("Updating list");
    if (todoList != null) {
      ListService.updateList( todoList!);
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
          fetched = await ListService.getList(widget.listName);
          break;
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
