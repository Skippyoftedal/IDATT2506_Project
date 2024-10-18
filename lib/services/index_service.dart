import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:idatt2506_project/model/index_file.dart';
import 'package:path_provider/path_provider.dart';

class IndexService {
  static final IndexService _singleton = IndexService._internal();

  static final List<FileItem> indexes = List.empty(growable: true);

  factory IndexService() {
    return _singleton;
  }

  IndexService._internal();

  Future<List<FileItem>> getIndexes(context) async {
    if (indexes.isEmpty) {
      await _fetchIndexes();
    }
    return indexes;
  }

  Future<void> _fetchIndexes() async {
    final directory = await getApplicationDocumentsDirectory();
    final indexFile = File("${directory.path}/lists/index.json");
    IndexFile parsed = IndexFile.fromJson(jsonDecode(await indexFile.readAsString()));
    log("Found json: $parsed");
    indexes.addAll(parsed.files);
  }
}
