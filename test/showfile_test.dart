import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:dungeonsound/showfile.dart';
import 'package:dungeonsound/playlist.dart';
import 'package:dungeonsound/soundsample.dart';

/// Loads a known `sample.showfile` with specific contents to use as a check
/// of the loading features for the ShowFile object.
void _testKnownGood() async {
  const String winPathToGoodFile = "G:\\My Drive\\DungeonSound\\sample.showfile";

  ShowFile result = ShowFile.fromFilepath(winPathToGoodFile);
  expect(result.name, "New Showfile");
  expect(result.backgroundPlaylists.length, 2);

  // Check pl0 contents
  Playlist pl0 = result.backgroundPlaylists[0];
  expect(pl0.name, "Dungeon Crawl");
  expect(pl0.volumeFactor, 0.9);
  expect(pl0.sampleList.length, 2);
  //ss0_0
  SoundSample ss0_0 = pl0.sampleList[0];
  expect(ss0_0.name, "Dracula's Theme");
  expect(ss0_0.startTimestamp, 0);
  expect(ss0_0.endTimestamp, 114.5);
  expect(ss0_0.volumeFactor, 0.8);
  Uri ssuri0_0 = Uri.file("G:/My Drive/Dungeons and Dragons/Castlevania Campaign I Guess/CastlevaniaMusic/DungeonCrawl/1-01 Dracula's Theme.mp3");
  expect(ss0_0.resourceUri, ssuri0_0);
  //ss0_1
  SoundSample ss0_1 = pl0.sampleList[1];
  expect(ss0_1.name, "Carmilla");
  expect(ss0_1.startTimestamp, 0);
  expect(ss0_1.endTimestamp, 114.5);
  expect(ss0_1.volumeFactor, 0.8);
  Uri ssuri0_1 = Uri.file("G:/My Drive/Dungeons and Dragons/Castlevania Campaign I Guess/CastlevaniaMusic/DungeonCrawl/2-12 Carmilla.mp3");
  expect(ss0_1.resourceUri, ssuri0_1);

  // Check pl1 contents
  Playlist pl1 = result.backgroundPlaylists[1];
  expect(pl1.name, "Dungeon Crawl, Encore");
  expect(pl1.volumeFactor, 0.9);
  expect(pl1.sampleList.length, 1);
  //ss1_0
  SoundSample ss1_0 = pl1.sampleList[0];
  expect(ss1_0.name, "Carmilla");
  expect(ss1_0.startTimestamp, 0);
  expect(ss1_0.endTimestamp, 114.5);
  expect(ss1_0.volumeFactor, 0.8);
  Uri ssuri1_0 = Uri.file("G:/My Drive/Dungeons and Dragons/Castlevania Campaign I Guess/CastlevaniaMusic/DungeonCrawl/2-12 Carmilla.mp3");
  expect(ss1_0.resourceUri, ssuri1_0);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("ShowFile", () {
    test("ShowFile constructable from known good file", _testKnownGood);
  });
}
