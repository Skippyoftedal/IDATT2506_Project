
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:idatt2506_project/model/index_file_item.dart';
import 'package:idatt2506_project/model/index_file.dart';
import 'package:idatt2506_project/model/todo_item.dart';
import 'package:idatt2506_project/model/todo_list.dart';

void main() {
  test('json parsing of index file', () {
    String fileContent = '''
    {
      "files": [
        {
          "listName": "test",
          "fileName": "test.json",
          "iconCodePoint":null
        }
      ]
    }
    ''';

    IndexFile expected =
    IndexFile(files: [IndexItem(listName: "test", fileName: "test.json")]);

    IndexFile actual = IndexFile.fromJson(jsonDecode(fileContent));

    expect(actual.files[0].listName, expected.files[0].listName);
    expect(actual.files[0].fileName, expected.files[0].fileName);

    expect(jsonEncode(expected.toJson()), jsonEncode(jsonDecode(fileContent)));
  });

  test('json parsing of todolist', () {
    String fileContent = '''
    {
      "completed": [
        {"item": "milk"}
      ],
      "inProgress":[
        {"item": "bread"}
      ]
    }
    ''';
    TodoItem item1 = TodoItem("milk");
    TodoItem item2 = TodoItem("bread");

    TodoList expected = TodoList(name: "This name is not checked", completed: [item1], inProgress: [item2]);

    TodoList actual = TodoList.fromJsonString(fileContent);

    expect(expected.completed, actual.completed);
    expect(jsonEncode(expected.toJson()), jsonEncode(jsonDecode(fileContent)));
  });
}
