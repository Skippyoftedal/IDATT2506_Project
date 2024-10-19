import 'dart:developer';

class FileItem {
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

    Map<String, dynamic> toJson() {
        return {"listName": listName, "fileName": fileName};
    }

    @override
    String toString() {
        return "{$listName: $fileName}";
    }
}