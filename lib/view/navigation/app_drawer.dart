import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:idatt2506_project/pages/list_page.dart';
import 'package:idatt2506_project/services/list_service.dart';
import 'package:idatt2506_project/view/navigation/route_widget.dart';
import 'package:idatt2506_project/view/navigation/routes.dart';
import 'package:idatt2506_project/view/navigation/todo_route.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<StatefulWidget> createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {
  List<TodoRoute> listRoutes = List.empty();

  @override
  initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    try {
      var lists = await ListService.getAllLists(context);

      setState(() {
        listRoutes = lists
            .map(
              (it) => TodoRoute(
                  it.name, (_) => ListPage(listName: it.name), Icons.list),
            )
            .toList();
      });

      log("Found lists $lists");
    } catch (e) {
      log("Could not retrieve list because: $e");
    }
  }

  @override
  Widget build(context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              color: Colors.lightBlueAccent,
              child: Column(
                children: [
                  for (var route in getTopNavigationRoutes())
                    RouteWidget(route: route),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.lightBlueAccent,
              child: ListView(
                padding: const EdgeInsets.only(top: 50),
                children: [
                  const Text(
                    "My lists",
                    textAlign: TextAlign.center,
                  ),
                  for (var route in listRoutes)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RouteWidget(route: route),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDeleteAlert(context, route.prettyName);
                          },
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
          Container(
              color: Colors.lightBlue,
              child: RouteWidget(route: getCreateNewListRoute()))
        ],
      ),
    );
  }

  showDeleteAlert(BuildContext context, String listToDelete) {
    Widget cancel = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget confirmDelete = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
        ListService.deleteList(listToDelete);
        fetchData();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Are you sure?"),
      content: const Text("The list will be deleted forever!"),
      actions: [
        cancel,
        confirmDelete,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
