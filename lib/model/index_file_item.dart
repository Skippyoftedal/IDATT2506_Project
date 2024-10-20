import 'dart:developer';

class IndexItem {
    final String listName;
    final String fileName;
    final int? iconCodePoint;

    IndexItem({required this.listName, required this.fileName, this.iconCodePoint});

    factory IndexItem.fromJson(Map<String, dynamic> json) {
        try {
            return IndexItem(listName: json["listName"], fileName: json["fileName"], iconCodePoint: json["iconCodePoint"]);
        } catch (e) {
            log("json parsing error for todoItem :$e");
            throw StateError("Cannot parse $json");
        }
    }

    Map<String, dynamic> toJson() {
        return {"listName": listName, "fileName": fileName, "iconCodePoint": iconCodePoint};
    }

    @override
    String toString() {
        return "{$listName: $fileName, $iconCodePoint}";
    }
}