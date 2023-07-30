import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:file_picker/src/platform_file.dart";
import "showfile.dart";


class ShowFileNotifier extends StateNotifier<ShowFile> {
  ShowFileNotifier() : super(ShowFile());

  int loadShowFile(PlatformFile file) {
    return state.loadShowFile(file);
  }

  int newShowFile(String? path) {
    return state.newShowFile(path);
  }
}