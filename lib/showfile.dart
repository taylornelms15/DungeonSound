import 'package:xml/xml.dart' as xml;
import 'dart:io';
import "playlist.dart";

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

  ShowFile.fromFilepath(String path)
    : this.fromXmlDocument(xml.XmlDocument.parse(File(path).readAsStringSync()))
  ;

  // Static members
  static const String elementName = "ShowFile";
  static const String _bgPlaylistsElementName = "BackgroundPlaylists";

  // Public members
  String name;

  PlaylistList backgroundPlaylists = <Playlist>[];

  // Playlist Loading

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