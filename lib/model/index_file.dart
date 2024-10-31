import 'dart:developer';

import 'index_file_item.dart';

/// Json model for the index file
///
/// The index file contains info about the different lists stored in the system.
/// This avoids fetching and parsing all the lists in the directory to retrieve
/// metadata such as the file names and icons.
class IndexFile {
  final List<IndexItem> files;

  IndexFile({required this.files});

  factory IndexFile.fromJson(Map<String, dynamic> json) {
    try {
      var filesJson = (json["files"] as List<dynamic>)
          .map((item) => IndexItem.fromJson(item))
          .toList();

      return IndexFile(files: filesJson);
    } catch (e) {
      log("json parsing error for todoItem :$e");
      throw StateError("Cannot parse $json");
    }
  }

  Map<String, dynamic> toJson() {
    return {"files": files};
  }

  @override
  String toString() {
    return "{${files.map((item) => "${item.listName} : ${item.fileName}").join(", ")}}";
  }
}
