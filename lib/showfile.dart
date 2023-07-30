import 'package:xml/xml.dart' as xml;
import 'dart:io';
import "package:file_picker/src/platform_file.dart";

import "playlist.dart";
import "ds_logging.dart";

typedef PlaylistList = List<Playlist>;

/// @brief Class representing a collection of playlists that a GM may want to play
///
/// This is primarily a collection of Playlist objects, and as such is designed to
/// retain knowledge of user-configurable attributes, but not any information
/// about current playback status.
///
/// This is also the gateway to saving/loading files, and as such is best thought of
/// as capturing everything that you would expect to be maintained between executions
/// of the overall program.
class ShowFile
{
  // Constructors
  ShowFile()
    : name = ""
  ;

  ShowFile.fromXmlElement(xml.XmlElement element)
    : assert(element.name.toString() == ShowFile.elementName)
    , name = element.getAttribute("title")!
  {
    for(final childElement in element.childElements) {
      if (childElement.name.toString() == ShowFile._bgPlaylistsElementName) {
        _loadBackgroundPlaylists(childElement);
      }
    }
  }

  ShowFile.fromXmlDocument(xml.XmlDocument document)
    : this.fromXmlElement(document.firstElementChild!)
  ;

  /// This is the preferred way to create a showfile by "Loading" a file,
  /// because it stores the filePath loaded to create it for easy saving later
  factory ShowFile.fromFilepath(String path)
  {
    xml.XmlDocument xmlDoc = xml.XmlDocument.parse(File(path).readAsStringSync());
    var result = ShowFile.fromXmlDocument(xmlDoc);
    result.filePath = path;
    return result;
  }

  // Static members
  static const String extension = "showfile";
  static const String elementName = "ShowFile";
  static const String _bgPlaylistsElementName = "BackgroundPlaylists";

  // Public members
  String name;
  String? filePath;

  PlaylistList backgroundPlaylists = <Playlist>[];

  // Saving/Loading Functions

  int loadShowFile(PlatformFile file)
  {
    logDebug("<ShowFile> Loading file from ${file.path}", LType.fileOperation);

    return 0;
  }

  int saveShowFile([String? path])
  {
    if (path != null) {
      filePath = path;
    }

    logDebug("Executing file save to $filePath", LType.fileOperation);

    assert(filePath != null);
    // Construct top-level xml element
    xml.XmlElement sfElement = xml.XmlElement(xml.XmlName(ShowFile.elementName));
    sfElement.setAttribute("title", name);
    xml.XmlElement bgElement = xml.XmlElement(xml.XmlName(ShowFile._bgPlaylistsElementName));
    sfElement.children.add(bgElement);
    _saveBackgroundPlaylists(bgElement);

    // Put XmlElement in a document
    xml.XmlDocument doc = xml.XmlDocument([sfElement]);

    // Save
    File outfile = File(filePath!);
    outfile.writeAsStringSync(doc.toXmlString(pretty: true, indent: "  "));

    return 0;
  }

  void _saveBackgroundPlaylists(xml.XmlElement bgElement)
  {
    assert(bgElement.name.toString() == ShowFile._bgPlaylistsElementName);
    for(final pl in backgroundPlaylists) {
      bgElement.children.add(pl.saveToXmlElement());
    }
  }

  void _loadBackgroundPlaylists(xml.XmlElement bgElement)
  {
    assert(bgElement.name.toString() == ShowFile._bgPlaylistsElementName);
    for(final childElement in bgElement.childElements) {
      if (childElement.name.toString() == Playlist.elementName) {
        backgroundPlaylists.add(Playlist.fromXmlElement(childElement));
      }
    }
  }
}