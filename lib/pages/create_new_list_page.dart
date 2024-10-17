import 'package:flutter/material.dart';
import 'package:idatt2506_project/services/list_service.dart';
import 'package:idatt2506_project/pages/list_page.dart';

import '../view/navigation/standard_scaffold.dart';

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
        child: Container(
          color: Colors.red,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Add new list"),
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Create new list",
                        fillColor: Colors.lightBlue,
                        filled: true),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    onPressed: () {
                      createListAndPush(context);
                    },
                    icon: const Icon(Icons.add),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createListAndPush(BuildContext context) {
    final title = textController.text;
    ListService.createEmptyList(title, context);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ListPage(listName: title)),
    );
  }
}
