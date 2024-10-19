import 'package:idatt2506_project/pages/create_new_list_page.dart';
import 'package:idatt2506_project/pages/list_page.dart';
import 'package:idatt2506_project/pages/test_pages.dart';
import 'package:flutter/material.dart';
import 'package:idatt2506_project/view/navigation/todo_route.dart';

class RouteManager {
  static final TodoRoute home =
      TodoRoute("Home", (_) => const ListPage(fileName: "1.json"), Icons.home);

  static final TodoRoute settings = TodoRoute("Settings",
      (_) => const TestPage(pageTitle: "test page 1"), Icons.settings);

  static final TodoRoute createNew =
      TodoRoute("Create New List", (_) => const CreateNewListPage(), Icons.add);

  /// Get static routes for the top part of the app drawer
  static List<TodoRoute> get topRoutes{
    return [home, settings];
  }
}
