import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:dungeonsound/showfile.dart';

void _testKnownGood() async {
  Directory current = Directory.current;
  print(current);
  final String winPathToGoodFile = "G:\\My Drive\\DungeonSound\\sample.showfile";

  ShowFile result = ShowFile.fromFilepath(winPathToGoodFile);
  expect(result.name, "New Showfile");
  expect(result.backgroundPlaylists.length, 2);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("ShowFile", () {
    test("ShowFile constructable from known good file", _testKnownGood);
  });
}
