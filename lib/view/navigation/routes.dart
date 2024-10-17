import 'package:idatt2506_project/pages/create_new_list_page.dart';
import 'package:idatt2506_project/pages/list_page.dart';
import 'package:idatt2506_project/pages/test_pages.dart';
import 'package:flutter/material.dart';
import 'package:idatt2506_project/view/navigation/todo_route.dart';


final _home = TodoRoute("Home", (_) => getMainPage(), Icons.home);

final _test1 = TodoRoute("Settings",
    (_) => const TestPage(pageTitle: "test page 1"), Icons.settings);

final _test2 = TodoRoute(
    "test 2", (_) => const TestPage(pageTitle: "test page 2"));

final _createNew = TodoRoute(
    "Create New List",
    (_) =>
        const CreateNewListPage(),
    Icons.add);

List<TodoRoute> getTopNavigationRoutes() {
  return [_home, _test1, _test2];
}

List<TodoRoute> getAllPossibleRoutes() {
  return [_home, _test1, _test2, _createNew];
}

Widget getMainPage() {
  //return const CreateNewListPage();
  return const ListPage(listName: "hyttetur");
}

TodoRoute getCreateNewListRoute() {
  return _createNew;
}

