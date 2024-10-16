import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/navigation/test_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as io;

import '../pages/home_page.dart';

class TodoRoute {
  final String prettyName;
  final String route;
  final Widget Function(BuildContext) component;

  TodoRoute(this.prettyName, this.route, this.component);
}

List<TodoRoute> getAllRoutes() {
  return [
    TodoRoute(
        "test 1", "/test1", (_) => const TestPage(pageTitle: "test page 1")),
    TodoRoute(
        "test 1", "/test1", (_) => const TestPage(pageTitle: "test page 1")),
    TodoRoute("Flutter demo home page", "/home",
        (_) => MyHomePage(title: 'Flutter Demo Home Page'))
  ];
}

Map<String, Widget Function(BuildContext)> getRoutesForRouter() =>
    {for (var route in getAllRoutes()) route.route: route.component};

TestPage getMainPage() => const TestPage(pageTitle: "This is the default page");




Future<TodoList> getList(BuildContext context, String fileLocation) async {
  String data = await DefaultAssetBundle.of(context).loadString(fileLocation);
  final json = jsonDecode(data);
  var todoList = TodoList.fromJson(json);
  return todoList;
}




Future<List<TodoList>> getAllLists(BuildContext context) async{
  // import 'package:path_provider/path_provider.dart';
  //
  // final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  // print(appDocumentsDir);

  return List.empty();

}
