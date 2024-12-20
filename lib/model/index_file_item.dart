import 'dart:developer';

import 'package:idatt2506_project/model/index_file.dart';

/// Part of the [IndexFile] class, saving metadata for each todolist
class IndexItem {
  final String listName;
  final String fileName;
  final int iconCodePoint;

  IndexItem(
      {required this.listName, required this.fileName, required this.iconCodePoint});

  factory IndexItem.fromJson(Map<String, dynamic> json) {
    try {
      return IndexItem(
          listName: json["listName"] as String,
          fileName: json["fileName"] as String,
          iconCodePoint: json["iconCodePoint"] as int);
    } catch (e) {
      log("json parsing error for todoItem :$e");
      throw StateError("Cannot parse $json");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "listName": listName,
      "fileName": fileName,
      "iconCodePoint": iconCodePoint
    };
  }

  @override
  String toString() {
    return "{$listName: $fileName, $iconCodePoint}";
  }
}
