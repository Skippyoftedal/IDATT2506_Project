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
      elevation: 2,
      backgroundColor: Colors.lightGreen,
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
      color: Colors.red,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Todo app",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  List<Widget> constantRoutes() {
    return RouteManager.getTopNavigationRoutes()
        .map(
          (route) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RouteWidget(route: route),
            ],
          ),
        )
        .toList();
  }

  List<Widget> dynamicRoutes() {
    return listRoutes
        .expand((route) => List.generate(10, (_) => route))
        .map(
          (route) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RouteWidget(route: route),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDeleteAlert(context, route.prettyName);
                },
              ),
            ],
          ),
        )
        .toList();
  }

  newListRoute() {
    return Container(
        color: Colors.lightBlue,
        child: RouteWidget(route: RouteManager.getCreateNewListRoute()));
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
