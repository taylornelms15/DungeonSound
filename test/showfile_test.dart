import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
//TODO: figure out why path_provider is being a bitch
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:path/path.dart' as p;

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

void _testSymmetricalSave() async {
  // Get the filepath for our temp file
  final PathProviderWindows provider = PathProviderWindows();
  String? tempDirStr = await provider.getTemporaryPath();
  Directory tempDir = Directory(tempDirStr!);
  String tmpFilePath = p.join(tempDir.path, "testShowfile.showfile");

  // Create a test showfile (mostly a lot of explicit data)
  ShowFile sf = ShowFile();
  Playlist pl0 = Playlist();
  pl0.name = "Battle Music";
  SoundSample ss0 = SoundSample(name: "Blood", startTimestamp: 0.0, endTimestamp: 45.111, volumeFactor: 0.7);
  Directory rootdir = Directory("G:\\My Drive\\Dungeons and Dragons\\Castlevania Campaign I Guess\\CastlevaniaMusic\\Battle");
  ss0.setResourceUrl(p.join(rootdir.path, "1-20 Blood.mp3"));
  pl0.sampleList.add(ss0);
  SoundSample ss1 = SoundSample(name: "God's Army", startTimestamp: 3.0, endTimestamp: 55.0, volumeFactor: 0.5);
  ss1.setResourceUrl(p.join(rootdir.path, "1-06 God's Army.mp3"));
  pl0.sampleList.add(ss1);
  Playlist pl1 = Playlist();
  pl1.name = "Final Battle Music";
  pl1.volumeFactor = 0.95;
  SoundSample ss2 = SoundSample(name: "Satan", startTimestamp: 0.0, endTimestamp: 240.0);
  ss2.setResourceUrl(p.join(rootdir.path, "3-21 Satan.mp3"));
  pl1.sampleList.add(ss2);
  sf.backgroundPlaylists.add(pl0);
  sf.backgroundPlaylists.add(pl1);

  // Save the test showfile
  sf.saveShowFile(tmpFilePath);

  // Load the test showfile into a new object
  File tmpFile = File(tmpFilePath);
  String resultString = tmpFile.readAsStringSync();
  ShowFile sf2 = ShowFile.fromFilepath(tmpFilePath);

  // Verify two ShowFile objects match
  expect(sf2.name, sf.name);
  expect(sf2.filePath, sf.filePath);
  expect(sf2.backgroundPlaylists.length, sf.backgroundPlaylists.length);
  for(int i = 0; i < sf.backgroundPlaylists.length; ++i) {
    expect(sf2.backgroundPlaylists[i], sf.backgroundPlaylists[i]);
  }

  // Delete temp file
  tmpFile.delete();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("ShowFile", () {
    test("ShowFile constructable from known good file", _testKnownGood);
    test("ShowFile saving and loading are symmetrically sound", _testSymmetricalSave);
  });
}
