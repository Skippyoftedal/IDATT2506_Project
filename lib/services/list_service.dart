import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:idatt2506_project/model/index_file_item.dart';
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
      list.iconCodePoint = Icons.ac_unit.codePoint;
      await saveList(list);
    }
  }

  static Future<void> deleteAllLists() async {
    log("WARNING: Removing all lists!");
    final directory = Directory(await localPath);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
    await directory.create();
    await IndexService().clearIndexes();
  }

  static Future<TodoList> getList(String listName) async {
    final IndexItem indexItem = await IndexService().getIndex(listName);
    final String fileName = indexItem.fileName;
    final String path = "${await localPath}/$fileName";
    try {
      log("path is $path");
      String listContent = await File(path).readAsString();
      TodoList list = TodoList.fromJsonString(listContent);
      list.iconCodePoint = indexItem.iconCodePoint;
      list.name = indexItem.listName;
      return list;
    } catch (e) {
      log(e.toString());
      throw StateError("Could not open list with name $listName at path $path");
    }
  }

  static Future<void> saveList(TodoList list) async {
    print("Here 3: ${list.iconCodePoint}");
    try {
      if (list.iconCodePoint == null) {
        throw StateError("Cannot save a list with no codepoint");
      }

      final filename = const Uuid().v4();
      log("Saving list with name ${list.name} and codepoint ${list.iconCodePoint} as $filename");
      //TODO remove
      await IndexService().filenameIsAvailable(filename);
      await IndexService().listNameIsAvailable(list.name);

      File file = File("${await localPath}/$filename");
      if (!await file.exists()) {
        file.create();
      }
      final String json = jsonEncode(list);
      file.writeAsString(json);
      IndexService().addIndex(IndexItem(
          listName: list.name,
          fileName: filename,
          iconCodePoint: list.iconCodePoint));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<void> deleteList(String listName) async {
    File file =
        File("${await localPath}/${await IndexService().getIndex(listName)}");
    if (await file.exists()) {
      await file.delete();
    }
    IndexService().removeList(listName);
  }

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/lists";
  }

  static Future<void> createEmptyList(
      {required String name, required int iconCodePoint}) async {
    print("Here 2: $iconCodePoint");
    await saveList(
      TodoList(
          name: name,
          inProgress: List.empty(),
          completed: List.empty(),
          iconCodePoint: iconCodePoint),
    );
  }
}
