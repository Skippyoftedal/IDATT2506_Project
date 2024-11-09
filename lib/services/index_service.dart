import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:idatt2506_project/error/already_exists_error.dart';
import 'package:idatt2506_project/model/index_file_item.dart';
import 'package:idatt2506_project/model/index_file.dart';
import 'package:path_provider/path_provider.dart';

/// Singleton class for managing the [IndexFile]
///
/// Note: to reduce the overhead of getting parsing the [IndexFile] too
/// many times, this class stores the [IndexItem] in memory after loading
/// them for the first time. Should a file be added without the usage of
/// this class (seen as an error), the link in the drawer
/// wont be available until an app restart.
class IndexService {
  static final IndexService _singleton = IndexService._internal();
  static final List<IndexItem> _indexes = List.empty(growable: true);
  static const String _indexPath = "lists/index.json";
  IndexService._internal();

  factory IndexService() {
    return _singleton;
  }

  bool isFetched = false;

  /// Tries to fetch indexes, if they are already fetched, nothing happens
  Future<void> updateIndexes() async {
    if (!isFetched) {
      isFetched = true;
      await _fetchIndexesFromFile();
    }
  }

  /// Fetches indexes from json index file, and adds them to [_indexes]
  Future<void> _fetchIndexesFromFile() async {
    log("Fetching indexes");

    String jsonString = await (await _indexFile).readAsString();
    Map<String, dynamic> jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    IndexFile parsed = IndexFile.fromJson(jsonMap);

    log("Found indexes from file: json: $parsed");
    _indexes.addAll(parsed.files);
  }

  Future<List<IndexItem>> get indexes async {
    await updateIndexes();

    log("indexes are: $_indexes");
    return _indexes;
  }

  /// Add an index to both [_indexes] and the stored index file
  Future<void> addIndex(IndexItem index) async {
    await updateIndexes();

    log("Adding $index to indexes");
    _indexes.add(index);
    await writeIndexes();
  }

  /// Returns the [IndexItem] that has the given [listName]
  ///
  /// A [StateError] is thrown if the [IndexItem] does not exist
  Future<IndexItem> getIndex(String listName) async {
    await updateIndexes();

    log("Trying to find filename for $listName");
    return _indexes.firstWhere((it) => it.listName == listName);
  }

  /// Throws an [AlreadyExistsError] if the item already exists
  Future<void> checkNameIsAvailable(String listName) async {
    await updateIndexes();

    if (_indexes.any((it) => it.listName == listName)) {
      throw AlreadyExistsError(listName);
    }
  }

  /// Clears indexes and deletes the index file
  Future<void> clearIndexes() async {
    _indexes.clear();
    (await _indexFile).delete();
  }

  /// Get the index file [File] from application storage
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
