import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:idatt2506_project/error/already_exists_error.dart';
import 'package:idatt2506_project/model/index_file_item.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/services/index_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Used for working on the stored lists
class ListService {

  static const listDirectoryPath = "lists";

  static Future<void> deleteAllLists() async {
    log("WARNING: Removing all lists!");
    final directory = Directory(await localPath);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
    await directory.create();
    await IndexService().clearIndexes();
  }

  /// Gets the list that has the given [listName]
  ///
  /// If the list does not exist, or cannot be opened, a [StateError] is thrown.
  static Future<TodoList> getList(String listName, {int simulateDelaySeconds = 0}) async {

    if (simulateDelaySeconds > 0){
      await Future.delayed(Duration(seconds: simulateDelaySeconds));
    }

    final IndexItem indexItem = await IndexService().getIndex(listName);
    final String fileName = indexItem.fileName;
    final String path = "${await localPath}/$fileName";
    try {
      log("path is $path");
      final String listContent = await File(path).readAsString();

      log("List content read is $listContent");

      final TodoList list = TodoList.fromJsonString(listContent);
      list.iconCodePoint = indexItem.iconCodePoint;
      list.name = indexItem.listName;
      return list;
    } catch (e) {
      log(e.toString());
      throw StateError("Could not open list with name $listName at path $path");
    }
  }

  /// Overwrites the current json version of the list in the filesystem
  static Future<void> updateList(TodoList list) async {
    try {

      final String filename =
          (await IndexService().getIndex(list.name)).fileName;
      log("Updating list with name ${list.name} and codepoint ${list.iconCodePoint} as $filename \n${list.toString()}");

      File file = File("${await localPath}/$filename");
      final String json = jsonEncode(list);
      await file.writeAsString(json);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  /// Saves a list with a new uuid name
  ///
  /// An [AlreadyExistsError] will be thrown if the name is already in use
  static Future<void> _saveNewList(TodoList list) async {
    try {

      await IndexService().checkNameIsAvailable(list.name);

      final filename = const Uuid().v4();
      log("Saving list with name ${list.name} and codepoint ${list.iconCodePoint} as $filename");
      log(list.toString());

      File file = File("${await localPath}/$filename");
      if (!await file.exists()) {
        log("$filename did not exist, creating new file");
        await file.create();
      }
      final String json = jsonEncode(list);
      file.writeAsString(json);

      await IndexService().addIndex(IndexItem(
          listName: list.name,
          fileName: filename,
          iconCodePoint: list.iconCodePoint));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  /// Delete a list with a given name
  static Future<void> deleteList(String listName) async {
    File file =
        File("${await localPath}/${await IndexService().getIndex(listName)}");
    if (await file.exists()) {
      await file.delete();
    }
    await IndexService().removeList(listName);
  }

  /// The path of the directory where the lists are stored
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$listDirectoryPath";
  }

  /// Create and save an empty list
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
