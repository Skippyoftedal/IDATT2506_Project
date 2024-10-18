import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/services/index_service.dart';
import 'package:path_provider/path_provider.dart';


class ListService {
  static Future<void> addTestDataToApplicationDocuments(context) async {

    final rootBundle = DefaultAssetBundle.of(context);

    final testDataNames = ["1.json", "2.json", "3.json", "index.json"];

    for (var name in testDataNames) {
      final fileContent = await rootBundle.loadString("assets/testdata/$name");

      final file = File("${await _localPath}/$name");
      if (!(await file.parent.exists())) {
        await file.parent.create(recursive: true);
      }
      await file.writeAsString(fileContent);
    }

    await IndexService().getIndexes(context);

  }

  static Future<void> removeAllLists() async {
    log("WARNING: Removing all lists!");
    final directory = Directory(await _localPath);
    if (await directory.exists()) {
      directory.delete(recursive: true);
    }
  }


//TODO this should be optimized
  static Future<TodoList?> getList(BuildContext context, String filename) async {
    try {
      String path = "${await _localPath}/$filename";
      log("path is $path");
      String listContent = await File(path).readAsString();
      return TodoList.fromJsonString(listContent);
    } catch (e) {
      throw StateError("Could not find list $filename, or the file is corrupt");
    }
  }

  static Future<bool> filename() async{
    return true;
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
    saveList(context, TodoList(name, List.empty(), List.empty()));
  }

  static Future<void> deleteList(String listName) async {
    final file = File("${await _localPath}/$listName.json");
    if (await file.exists()) {
      file.delete();
    }
  }
}
