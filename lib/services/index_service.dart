import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:idatt2506_project/exceptions/already_exists_error.dart';
import 'package:idatt2506_project/model/index_file_item.dart';
import 'package:idatt2506_project/model/index_file.dart';
import 'package:path_provider/path_provider.dart';

class IndexService {
  static final IndexService _singleton = IndexService._internal();
  static final List<IndexItem> _indexes = List.empty(growable: true);
  static const String _indexPath = "lists/index.json";
  IndexService._internal();

  factory IndexService() {
    return _singleton;
  }

  bool isFetched = false;


  Future<void> updateIndexes() async {
    if (!isFetched) {
      isFetched = true;
      await _fetchIndexesFromFile();
    }
  }

  Future<void> _fetchIndexesFromFile() async {
    log("Fetching indexes");
    IndexFile parsed =
    IndexFile.fromJson(jsonDecode(await (await _indexFile).readAsString()));
    log("Found indexes from file: json: $parsed");
    _indexes.addAll(parsed.files);
  }

  Future<List<IndexItem>> get indexes async {
    await updateIndexes();

    log("indexes are: $_indexes");
    return _indexes;
  }

  Future<void> addIndex(IndexItem index) async {
    await updateIndexes();

    log("Adding $index to indexes");
    _indexes.add(index);
    await writeIndexes();
  }

  Future<IndexItem> getIndex(String listName) async {
    await updateIndexes();

    log("Trying to find filename for $listName");
    return _indexes.firstWhere((it) => it.listName == listName);
  }


  Future<void> checkNameIsAvailable(String listName) async {
    await updateIndexes();

    if (_indexes.any((it) => it.listName == listName)) {
      throw AlreadyExistsError(listName);
    }
  }

  Future<void> clearIndexes() async {
    _indexes.clear();
    (await _indexFile).delete();
  }

  Future<File> get _indexFile async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File("${directory.path}/$_indexPath");

    if (!await file.exists()) {
      log("Index file does not exist, will be created now");
      await file.create();
      await file.writeAsString(jsonEncode(IndexFile(files: List.empty())));
    }
    return file;
  }

  Future<void> removeList(String listName) async {
    _indexes.removeWhere((it) => it.listName == listName);
    writeIndexes();
  }

  Future<void> writeIndexes()async {
    await updateIndexes();

    log("Writing indexes: $_indexes to file");
    File file = await _indexFile;
    await file.writeAsString(jsonEncode(IndexFile(files: _indexes)));
  }
}
