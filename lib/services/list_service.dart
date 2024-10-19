import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:idatt2506_project/model/index_file.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/services/index_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ListService {
  static Future<void> addTestData(AssetBundle rootBundle) async {
    final testDataNames = ["empty", "hyttetur", "middag"];

    for (var name in testDataNames) {
      final fileContent = await rootBundle.loadString("assets/testdata/$name");
      final list = TodoList.fromJsonString(fileContent);
      list.name = name;
      saveList(list);
    }
  }

  static Future<void> removeAllLists() async {
    log("WARNING: Removing all lists!");
    final directory = Directory(await localPath);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
    await directory.create();
    await IndexService().clearIndexes();
  }

  static Future<TodoList> getList(String listName) async {
    final String fileName = await IndexService().getFileName(listName);
    final String path = "${await localPath}/$fileName";
    try {
      log("path is $path");
      String listContent = await File(path).readAsString();
      TodoList list = TodoList.fromJsonString(listContent);
      list.name = listName;
      return list;
    } catch (e) {
      log(e.toString());
      throw StateError("Could not open list with name $listName at path $path");
    }
  }

  static Future<void> saveList(TodoList list) async {
    try {
      final filename = const Uuid().v4();
      log("Saving list with name ${list.name} as $filename");

      await IndexService().filenameIsAvailable(filename);
      await IndexService().listNameIsAvailable(list.name);

      File file = File("${await localPath}/$filename");
      if (!await file.exists()) {
        file.create();
      }
      final json = jsonEncode(list);
      file.writeAsString(json);
      IndexService()
          .addIndex(FileItem(listName: list.name, fileName: filename));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/lists";
  }

  static Future<void> createEmptyList(String name) async {
    await saveList(TodoList(name, List.empty(), List.empty()));
  }

  static Future<void> deleteList(String listName) async {
    final file = File(
        "${await localPath}/${await IndexService().getFileName(listName)}");
    if (await file.exists()) {
      file.delete();
    }
  }
}
