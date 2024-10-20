import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:idatt2506_project/model/index_file_item.dart';
import 'package:idatt2506_project/model/index_file.dart';
import 'package:path_provider/path_provider.dart';

class IndexService {
  static final IndexService _singleton = IndexService._internal();
  static final List<IndexItem> _indexes = List.empty(growable: true);

  IndexService._internal();

  factory IndexService() {
    return _singleton;
  }

  bool isFetched = false;

  Future<List<IndexItem>> getIndexes() async {
    await updateIndexes();
    log("indexes are: $_indexes");
    return _indexes;
  }

  Future<void> addIndex(IndexItem index) async {
    log("Adding $index to indexes");
    await updateIndexes();
    _indexes.add(index);
    updateIndexes();
  }

  Future<IndexItem> getIndex(String listName) async {
    log("Trying to find filename for $listName");
    await updateIndexes();
    return _indexes.firstWhere((it) => it.listName == listName);
  }

  Future<void> filenameIsAvailable(String filename) async {
    await updateIndexes();
    if (_indexes.any((it) => it.fileName == filename)) {
      throw ArgumentError("Filename '$filename' is already in use.");
    }
  }

  Future<void> listNameIsAvailable(String listName) async {
    await updateIndexes();

    if (_indexes.any((it) => it.listName == listName)) {
      throw ArgumentError("List name '$listName' is already in use.");
    }
  }

  Future<void> _fetchIndexesFromFile() async {
    log("Fetching indexes");
    IndexFile parsed =
        IndexFile.fromJson(jsonDecode(await (await _indexFile).readAsString()));
    log("Found json: $parsed");
    _indexes.addAll(parsed.files);
  }

  Future<void> updateIndexes() async {
    if (!isFetched) {
      isFetched = true;
      await _fetchIndexesFromFile();
    }
  }

  Future<void> clearIndexes() async {
    _indexes.clear();
    (await _indexFile).delete();
  }

  Future<File> get _indexFile async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File("${directory.path}/lists/index.json");

    if (!await file.exists()) {
      log("Index file does not exist, will be created now");
      await file.create();
      await file.writeAsString(jsonEncode(IndexFile(files: List.empty())));
    }
    return file;
  }

  void removeList(String listName) {
    _indexes.removeWhere((it) => it.listName == listName);
  }
}
