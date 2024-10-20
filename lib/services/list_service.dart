import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:idatt2506_project/model/index_file_item.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/services/index_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ListService {
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
      final String listContent = await File(path).readAsString();

      print("List content read is $listContent");

      final TodoList list = TodoList.fromJsonString(listContent);
      list.iconCodePoint = indexItem.iconCodePoint;
      list.name = indexItem.listName;
      return list;
    } catch (e) {
      log(e.toString());
      throw StateError("Could not open list with name $listName at path $path");
    }
  }

  static Future<void> updateList(TodoList list) async {
    try {
      if (list.iconCodePoint == null) {
        throw StateError("Cannot save a list with no codepoint");
      }

      final String filename =
          (await IndexService().getIndex(list.name)).fileName;
      log("Updating list with name ${list.name} and codepoint ${list.iconCodePoint} as $filename \n${list.toString()}");

      File file = File("${await localPath}/$filename");
      final String json = jsonEncode(list);
      file.writeAsString(json);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<void> _saveNewList(TodoList list) async {
    try {
      if (list.iconCodePoint == null) {
        throw StateError("Cannot save a list with no codepoint");
      }

      final filename = const Uuid().v4();
      log("Saving list with name ${list.name} and codepoint ${list.iconCodePoint} as $filename");
      log(list.toString());

      File file = File("${await localPath}/$filename");
      if (!await file.exists()) {
        log("Print $filename did not exist, creating new file");
        await file.create();
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
    await IndexService().removeList(listName);
  }

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/lists";
  }

  static Future<void> createEmptyList(
      {required String name, required int iconCodePoint}) async {
    await _saveNewList(
      TodoList(
          name: name,
          inProgress: List.empty(),
          completed: List.empty(),
          iconCodePoint: iconCodePoint),
    );
  }
}
