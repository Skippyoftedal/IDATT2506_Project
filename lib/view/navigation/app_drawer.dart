import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:idatt2506_project/pages/list_page.dart';
import 'package:idatt2506_project/services/index_service.dart';
import 'package:idatt2506_project/services/list_service.dart';
import 'package:idatt2506_project/view/error/critical_error.dart';
import 'package:idatt2506_project/view/navigation/route_widget.dart';
import 'package:idatt2506_project/services/route_service.dart';
import 'package:idatt2506_project/model/todo_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  /// Gets all available lists
  Future<void> fetchData() async {
    try {
      final lists = await IndexService().indexes;
      setState(() {
        listRoutes = lists
            .map(
              (it) => TodoRoute(it.listName,
                  (_) => ListPage(listName: it.listName), it.iconCodePoint),
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
          //...constantRoutes(),
          Expanded(
            child: ListView(
                padding: EdgeInsets.zero,
                children: [...dynamicRoutes().reversed]),
          ),
          newListRoute()
        ],
      ),
    );
  }

  /// Title header for the drawer
  Widget drawerHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.appName,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize),
          )
        ],
      ),
    );
  }

  /// List of all [listRoutes] mapped to [RouteWidget]
  List<Widget> dynamicRoutes() {
    return listRoutes
        .map(
          (route) => RouteWidget(
            route: route,
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => showDeleteAlert(context, route.prettyName),
            ),
          ),
        )
        .toList();
  }

  /// Bottom route for creating a new list
  Widget newListRoute() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: RouteWidget(
        route: RouteService.createNew(
            prettyName:
                AppLocalizations.of(context)!.createNewListRouteButtonText),
      ),
    );
  }

  /// Shows an alert when trying to delete a list, making sure it is what
  /// the user really wants.
  Future<void> showDeleteAlert(
      BuildContext context, String listToDelete) async {
    Widget cancel = TextButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith(
              (_) => Theme.of(context).colorScheme.surfaceContainerHighest)),
      child: Text(
        AppLocalizations.of(context)!.cancelButtonText,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget confirmDelete = TextButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith((_) => Colors.red)),
      child: Text(
        AppLocalizations.of(context)!.confirmDelete,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        try {
          Navigator.of(context).pop();
          await ListService.deleteList(listToDelete);
          await fetchData();
        } catch (_) {
          CriticalError.generic(context).show(context);
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context)!.areYouSurePrompt),
      content: Text(AppLocalizations.of(context)!.listDeletedForeverWarning),
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
