import 'dart:developer';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:idatt2506_project/exceptions/already_exists_error.dart';
import 'package:idatt2506_project/exceptions/empty_input_exception.dart';
import 'package:idatt2506_project/exceptions/only_whitespace_error.dart';
import 'package:idatt2506_project/services/index_service.dart';
import 'package:idatt2506_project/services/list_service.dart';
import 'package:idatt2506_project/model/todo_item.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/view/error/critical_error.dart';
import 'package:idatt2506_project/view/navigation/standard_scaffold.dart';
import 'package:idatt2506_project/view/todo/reorderable_item_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Page for displaying and editing a list
class ListPage extends StatefulWidget {
  /// The name of the list, identifies it in the [IndexService]
  final String listName;

  const ListPage({super.key, required this.listName});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  /// The current list
  ///
  /// Null if the list has not been retrieved yet
  TodoList? todoList;


  /// [TextEditingController] for the bottom text input for adding
  /// a new [TodoItem] to [todoList]
  final itemInputTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StandardScaffold(
      title: todoList?.name,
      body: todoList == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            )
          : Column(
              children: [
                if (todoList?.hasNoItems() ?? false)
                  Container(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: listIsEmptyMessage(),
                  ),
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
                        controller: itemInputTextController,
                        onSubmitted: (submission) {
                          itemInputTextController.text = "";
                          addTodoListItem(submission);
                        },
                        onEditingComplete: () {},
                        decoration: InputDecoration(
                            enabledBorder: getTextFieldBorder(),
                            focusedBorder: getTextFieldBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                addTodoListItem(itemInputTextController.text);
                                itemInputTextController.text = "";
                              },
                              icon: Icon(Icons.send,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            hintText:
                                AppLocalizations.of(context)!.addNewItemToList),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  /// Chat bubble letting the user know that the list is empty
  Widget listIsEmptyMessage() {
    return BubbleSpecialThree(
      text: AppLocalizations.of(context)!.emptyListMessageHint,
      color: Theme.of(context).colorScheme.tertiary,
      textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onTertiary, fontSize: 18),
    );
  }

  /// Border for the bottom [TextField]
  OutlineInputBorder getTextFieldBorder() {
    return OutlineInputBorder(
      borderSide:
          BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );
  }

  /// Tries to add a [TodoItem], displaying an error if something goes wrong.
  ///
  /// The list is updated in the file system every time an item is added
  void addTodoListItem(String text) {
    String? errorMessage;
    setState(() {
      try {
        todoList?.addTodoItem(item: TodoItem(text), isCompleted: false);
        updateList();
      } on AlreadyExistsError catch (e) {
        errorMessage =
            AppLocalizations.of(context)?.itemAlreadyExits(e.toString());
      } on OnlyWhitespaceError catch (_) {
        errorMessage = AppLocalizations.of(context)?.whitespaceItemError;
      } on EmptyInputError catch (_) {
        errorMessage = AppLocalizations.of(context)?.emptyItemError;
      } catch (e) {
        errorMessage = e.toString();
        log(e.toString());
      }
    });

    if (errorMessage != null) {
      CriticalError(errorMessage: errorMessage!).show(context);
    }
  }

  /// Updates the list in the list service
  Future<void> updateList() async {
    log("Updating list");

    if (todoList != null) {
      try{
        await ListService.updateList(todoList!);
      } catch (_){
        if (mounted){
          String message = AppLocalizations.of(context)?.genericError ?? "";
          CriticalError(errorMessage: message).show(context);
        }
      }
    }
  }

  /// Gets the name from the [ListService] based on the name of the list
  void fetchList() async {
    try {
      TodoList? fetched;
      //TODO, remove delay before shipping
      fetched = await ListService.getList(widget.listName, simulateDelaySeconds: 1);

      log("fetched list $fetched");
      setState(() {
        todoList = fetched;
      });
    } catch (e) {
      if (mounted) CriticalError.generic(context).show(context);
    }
  }

  @override
  void initState() {
    fetchList();
    super.initState();
  }

  @override
  void dispose() {
    itemInputTextController.dispose();
    super.dispose();
  }
}
