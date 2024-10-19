
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:idatt2506_project/model/FileItem.dart';
import 'package:idatt2506_project/model/index_file.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {});

  test('json parsing of index file', () {
    String fileContent = '''
    {
      "files": [
        {
          "listName": "test",
          "fileName": "test.json"
        }
      ]
    }
    ''';

    IndexFile expected =
    IndexFile(files: [FileItem(listName: "test", fileName: "test.json")]);

    IndexFile actual = IndexFile.fromJson(jsonDecode(fileContent));

    expect(actual.files[0].listName, expected.files[0].listName);
    expect(actual.files[0].fileName, expected.files[0].fileName);

    expect(jsonEncode(expected.toJson()), jsonEncode(jsonDecode(fileContent)));
  });
}
