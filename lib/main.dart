import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import "ds_logging.dart";

import "showfile.dart";
import "showfilenotifier.dart";

final showfileProvider = StateNotifierProvider<ShowFileNotifier, ShowFile>(
    (ref) {
      return ShowFileNotifier();
    }
);

void main() async{
  runApp(
    const ProviderScope (
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Dungeon Sound',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DSHomePage(title: 'Dungeon Sound'),
    );
  }
}

class DSAppBar extends ConsumerStatefulWidget  implements PreferredSizeWidget{
  const DSAppBar({super.key, required this.title}) :
    preferredSize = const Size.fromHeight(kToolbarHeight);

  final String title;

  @override
  final Size preferredSize;

  @override
  ConsumerState<DSAppBar> createState() => _DSAppBarState();
}

class _DSAppBarState extends ConsumerState<DSAppBar> {
  Future<String?>? saveFilePickerResult;
  Future<FilePickerResult?>? openFilePickerResult;

  // Button Actions

  void _executeOpenButton(BuildContext context) {
    setState(() {
      openFilePickerResult = FilePicker.platform.pickFiles(
        dialogTitle: "Open ShowFile",
        type: FileType.custom,
        allowedExtensions: [ShowFile.extension],
        allowMultiple: false,
        lockParentWindow: true,
      );
      openFilePickerResult!.then(_executeOpenButtonFilePicked);
    });
  }

  void _executeOpenButtonFilePicked(FilePickerResult? pickedFile) {
    logDebug("Open file result: ${pickedFile}", LType.fileOperation);
    if (pickedFile == null || pickedFile.count == 0) {
      logInfo("No file picked to load", LType.debug);
      return;
    }
    assert(pickedFile.count == 1);
    PlatformFile picked = pickedFile.files[0];
    logInfo("Path ${picked.path}, name ${picked.name}, extension ${picked.extension}", LType.fileOperation);

    ref.read(showfileProvider).loadShowFile(picked);
  }

  void _executeSaveAsButton(BuildContext context) {
    setState(() {
      saveFilePickerResult = FilePicker.platform.saveFile(dialogTitle: "Save ShowFile",
          type: FileType.custom,
          allowedExtensions: [ShowFile.extension]);
      saveFilePickerResult!.then(_executeSaveAsButtonFilePicked);
    }); // setState
  }

  void _executeSaveAsButtonFilePicked(String? pickedFilePath) {
    logInfo("Picked save path: $pickedFilePath", LType.fileOperation);
    saveFilePickerResult = null;
    if (pickedFilePath == null) {
      logInfo("No file path picked to save", LType.debug);
      return;
    }

    ref.read(showfileProvider).saveShowFile(pickedFilePath);
  }

  // Button Press Callbacks

  void _onNewButton(BuildContext context) {
    logInfo("New Button Pressed", LType.buttonPress);
  }

  void _onSaveButton(BuildContext context) {
    logInfo("Save Button Pressed", LType.buttonPress);
    if (ref.read(showfileProvider).filePath != null) {
      ref.read(showfileProvider).saveShowFile();
    } else {
      logDebug("No file path associated with ShowFile, opening picker dialog", LType.fileOperation);
      _executeSaveAsButton(context);
    }
  }

  void _onSaveAsButton(BuildContext context) {
    logInfo("Save As Button Pressed", LType.buttonPress);
    _executeSaveAsButton(context);
  }

  void _onOpenButton(BuildContext context) {
    logInfo("Open Button Pressed", LType.buttonPress);
    _executeOpenButton(context);
  }

  void _onSettingsButton(BuildContext context) {
    logInfo("Settings Button Pressed", LType.buttonPress);
  }

  void _onInfoButton() {
    logInfo("Info Button Pressed", LType.buttonPress);
  }

  @override
  Widget build(BuildContext context) {
    AppBar retval = AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.create),
          tooltip: "New Showfile",
          onPressed: () {
            _onNewButton(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: "Save Showfile",
          onPressed: () {
            _onSaveButton(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.save_as),
          tooltip: "Save Showfile as",
          onPressed: () {
            _onSaveAsButton(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.file_open),
          tooltip: "Open Showfile",
          onPressed: () {
            _onOpenButton(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: "Showfile Settings",
          onPressed: () {
            _onSettingsButton(context);
          },
        ),
        FutureBuilder<PackageInfo> (
            future: PackageInfo.fromPlatform(),
            builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                    icon: const Icon(Icons.info),
                    tooltip: "Info about Dungeon Sound",
                    onPressed: () {
                      _onInfoButton();
                      setState(() {
                        logInfo("showInfoDialog", LType.debug);
                        showAboutDialog(context: context,
                          applicationVersion: snapshot.data?.version,
                          applicationName: "Dungeon Sound",
                          children: [
                            Text('Package name: ${snapshot.data?.appName}'),
                            Text('Build number: ${snapshot.data?.buildNumber}'),
                          ],//Children
                        );// showAboutDialog
                      }); // setState
                    }
                );
              } else {
                return const IconButton(
                  icon: Icon(Icons.info),
                  tooltip: "Info about Dungeon Sound",
                  onPressed: null,
                );
              } // else
            } // builder
        ),
      ],
    );
    return retval;
  } // build
}

class DSHomePage extends ConsumerStatefulWidget {
  const DSHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  ConsumerState<DSHomePage> createState() => _DSHomePageState();

}

class _DSHomePageState extends ConsumerState<DSHomePage> {
  int _counter = 0;
  Future<String?>? saveFilePickerResult;
  Future<FilePickerResult?>? openFilePickerResult;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: DSAppBar(title: widget.title),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
