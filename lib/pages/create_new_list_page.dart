import 'package:flutter/material.dart';
import 'package:idatt2506_project/services/list_service.dart';
import 'package:idatt2506_project/pages/list_page.dart';
import 'package:idatt2506_project/view/error/critical_error.dart';
import 'package:idatt2506_project/view/navigation/standard_scaffold.dart';

class CreateNewListPage extends StatefulWidget {
  const CreateNewListPage({super.key});

  @override
  State<CreateNewListPage> createState() => _CreateNewListPageState();
}

class _CreateNewListPageState extends State<CreateNewListPage> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StandardScaffold(
      body: Container(
        color: Colors.amberAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Add new list"),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: TextField(
                  controller: textController,
                  onSubmitted: (_) {
                    createListAndPush();
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Give your list a name",
                    fillColor: Colors.lightBlue,
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        createListAndPush();
                      },
                      icon: Icon(Icons.add_circle_outline,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createListAndPush()async {
    final NavigatorState navigator = Navigator.of(context);
    final title = textController.text;
    String? errorMessage;
    try{
      await ListService.createEmptyList(title);
      navigator.push(
        MaterialPageRoute(builder: (_) => ListPage(listName: title)),
      );
    } catch(e){
      errorMessage = e.toString();

    }

    if (errorMessage != null){
      showError(errorMessage);
    }

  }

  void showError(String message){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CriticalError(errorMessage: message);
      },
    );
  }
}
