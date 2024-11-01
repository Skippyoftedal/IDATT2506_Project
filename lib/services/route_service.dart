import 'package:idatt2506_project/pages/create_new_list_page.dart';
import 'package:flutter/material.dart';
import 'package:idatt2506_project/model/todo_route.dart';

class RouteService {

  /// The start-page of the application
  static final TodoRoute home =
      TodoRoute("", (_) => const CreateNewListPage(), Icons.home.codePoint);

  /// Route to the "create new list" page
  static TodoRoute createNew({required String prettyName}) =>
      TodoRoute(prettyName, (_) => const CreateNewListPage(), Icons.add.codePoint);


}
