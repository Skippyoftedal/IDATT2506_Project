import 'package:flutter/material.dart';
import 'package:idatt2506_project/model/todo_list.dart';

import 'list_service.dart';

class TestDataService{
  static Future<void> addTestData(AssetBundle rootBundle) async {
    final testDataNames = ["empty", "hyttetur", "middag"];
    final testDataIcons = [Icons.list.codePoint, Icons.list.codePoint, Icons.list.codePoint];

    for (int i = 0; i <testDataNames.length; i++) {
      final fileContent = await rootBundle.loadString("assets/testdata/${testDataNames[i]}");
      final list = TodoList.fromJsonString(fileContent);
      list.name = testDataNames[i];
      list.iconCodePoint = testDataIcons[i];
      await ListService.createEmptyList(name: testDataNames[i], iconCodePoint: testDataIcons[i]);
      await ListService.updateList(list);
    }
  }
}