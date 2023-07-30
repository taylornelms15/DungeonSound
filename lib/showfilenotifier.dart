import 'package:flutter_riverpod/flutter_riverpod.dart';
import "showfile.dart";


class ShowFileNotifier extends StateNotifier<ShowFile> {
  ShowFileNotifier() : super(ShowFile());
}