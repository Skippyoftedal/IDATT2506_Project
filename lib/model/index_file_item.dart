import 'dart:developer';

class IndexItem {
    final String listName;
    final String fileName;

    IndexItem({required this.listName, required this.fileName});

    factory IndexItem.fromJson(Map<String, dynamic> json) {
        try {
            return IndexItem(listName: json["listName"], fileName: json["fileName"]);
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