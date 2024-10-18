import 'package:idatt2506_project/pages/create_new_list_page.dart';
import 'package:idatt2506_project/pages/list_page.dart';
import 'package:idatt2506_project/pages/test_pages.dart';
import 'package:flutter/material.dart';
import 'package:idatt2506_project/view/navigation/todo_route.dart';

class RouteManager{
  static final _home = TodoRoute("Home", (_) => getMainPage(), Icons.home);

  static final _test1 = TodoRoute("Settings",
          (_) => const TestPage(pageTitle: "test page 1"), Icons.settings);

  static final _test2 = TodoRoute(
      "test 2", (_) => const TestPage(pageTitle: "test page 2"));

  static final _createNew = TodoRoute(
      "Create New List",
          (_) =>
      const CreateNewListPage(),
      Icons.add);

  static List<TodoRoute> getTopNavigationRoutes() {
    return [_home, _test1, _test2];
  }

  static List<TodoRoute> getAllPossibleRoutes() {
    return [_home, _test1, _test2, _createNew];
  }

  static Widget getMainPage() {
    //return const CreateNewListPage();
    return const ListPage(fileName: "1.json");
  }

  static TodoRoute getCreateNewListRoute() {
    return _createNew;
  }
}


