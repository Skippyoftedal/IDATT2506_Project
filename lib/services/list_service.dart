import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../model/todo_list.dart';

class ListService {
  static Future<void> addTestDataToApplicationDocuments(context) async {
    final rootBundle = DefaultAssetBundle.of(context);

    final testDataNames = ["hyttetur.json", "middag.json"];

    for (var name in testDataNames) {
      final fileContent = await rootBundle.loadString("assets/testdata/$name");

      final file = File("${await _localPath}/$name");
      if (!(await file.parent.exists())) {
        await file.parent.create(recursive: true);
      }
      file.writeAsString(fileContent);
    }
  }

  static Future<void> removeAllLists() async {
    log("WARNING: Removing all lists!");
    final directory = Directory(await _localPath);
    if (await directory.exists()) {
      directory.delete(recursive: true);
    }
  }

  static Future<List<String>> getAllListsPaths(BuildContext context) async {
    final Directory todoListDirectory;
    {
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      todoListDirectory = Directory("${appDocumentsDir.path}/lists");
    }

    final List<String> paths = await todoListDirectory
        .list(recursive: false)
        .map((it) => it.path)
        .toList();
    log("Paths found in directory 'lists': $paths");

    return paths;
  }

  static Future<List<TodoList>> getAllLists(context) async {
    final paths = await getAllListsPaths(context);
    List<File> files = paths.map((it) => File(it)).toList();

    List<TodoList> todoLists = await Future.wait(
      files.map((it) async {
        String content = await File(it.path).readAsString();
        var list = TodoList.fromJsonString(content);
        return list;
      }).toList(),
    );
    return todoLists;
  }

//TODO this should be optimized
  static Future<TodoList?> getList(BuildContext context, String name) async {
    try {
      return (await getAllLists(context))
          .firstWhere((it) => it.name.toLowerCase() == name.toLowerCase());
    } catch (e) {
      throw StateError("Could not find list, or the file is corrupt");
    }
  }

  static Future<void> saveList(BuildContext context, TodoList list) async {
    try {
      log("Saving list");

      File file = File("${await _localPath}/${list.name}.json");
      if (!await file.exists()) {
        file.create();
      }
      final json = jsonEncode(list);
      file.writeAsString(json);
    } catch (e) {
      log(e.toString());
      throw StateError("could not save list");
    }
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/lists";
  }

  static Future<void> createEmptyList(String name, context) async {
    saveList(context, TodoList(name, List.empty()));
  }

  static Future<void> deleteList(String listName) async {
    final file = File("${await _localPath}/$listName.json");
    if (await file.exists()) {
      file.delete();
    }
  }
}
