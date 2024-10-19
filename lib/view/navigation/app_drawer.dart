import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:idatt2506_project/pages/list_page.dart';
import 'package:idatt2506_project/services/index_service.dart';
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

  Future<void >fetchData() async {
    try {
      var lists = await IndexService().getIndexes();
      setState(() {
        listRoutes = lists
            .map(
              (it) => TodoRoute(
                  it.listName, (_) => ListPage(listName: it.listName), Icons.list),
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
      elevation: 2,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        children: [
          drawerHeader(),
          ...constantRoutes(),
          Expanded(
            child: ListView(
                padding: EdgeInsets.zero, children: [...dynamicRoutes()]),
          ),
           newListRoute()
        ],
      ),
    );
  }

  drawerHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      color: Theme.of(context).colorScheme.primary,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Todo app",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize
            ),
          )
        ],
      ),
    );
  }

  List<Widget> constantRoutes() {
    return RouteManager.topRoutes
        .map((route) => RouteWidget(route: route),

        )
        .toList();
  }

  List<Widget> dynamicRoutes() {
    return listRoutes
        .expand((route) => List.generate(1, (_) => route))//TODO delete before release
        .map(
          (route) =>
              RouteWidget(route: route, trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDeleteAlert(context, route.prettyName);
                },),
          ),
        )
        .toList();
  }

  newListRoute() {
    return Container(
        color: Theme.of(context).colorScheme.primary,
        child: RouteWidget(route: RouteManager.createNew));
  }

  Future<void> showDeleteAlert(BuildContext context, String listToDelete) async {
    Widget cancel = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget confirmDelete = TextButton(
      child: const Text("Continue"),
      onPressed: () async {
        Navigator.of(context).pop();
        await ListService.deleteList(listToDelete);
        await fetchData();
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
