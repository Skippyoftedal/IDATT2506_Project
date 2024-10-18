import 'dart:developer';

class IndexFile {
  final List<FileItem> files;

  IndexFile({required this.files});

  factory IndexFile.fromJson(Map<String, dynamic> json) {
    try {
      var filesJson = (json["files"] as List<dynamic>)
          .map((item) => FileItem.fromJson(item))
          .toList();

      return IndexFile(files: filesJson);
    } catch (e) {
      log("json parsing error for todoItem :$e");
      throw StateError("Cannot parse $json");
    }
  }

  @override
  String toString() {
    return "{${files
        .map((item) => "${item.listName} : ${item.fileName}")
        .join(", ")}}";
  }
}

class FileItem{
  final String listName;
  final String fileName;

  FileItem({required this.listName, required this.fileName});

  factory FileItem.fromJson(Map<String, dynamic> json) {
    try {
      return FileItem(listName: json["listName"], fileName: json["fileName"]);
    } catch (e) {
      log("json parsing error for todoItem :$e");
      throw StateError("Cannot parse $json");
    }
  }


}
