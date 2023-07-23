import 'package:xml/xml.dart' as xml;
import "soundsample.dart";

typedef SoundSampleList = List<SoundSample>;

/// @brief Class representing a playable collection of sound samples
///
/// This class represents everything that can be set by a user for
/// designing a collection of sounds to later play back.
/// It is not meant to be reflective of any current playback status.
class Playlist
{
  // Constructors
  Playlist()
    : name = ""
    , sampleList = <SoundSample>[]
  ;

  Playlist.fromXmlElement(xml.XmlElement element)
    : assert(element.name.toString() == Playlist.elementName)
    , name = element.getAttribute("title")!
    , sampleList = <SoundSample>[]
  {
    for(final childElement in element.childElements) {
      if (childElement.name.toString() == SoundSample.elementName) {
        sampleList.add(SoundSample.fromXmlElement(childElement));
      }
    }
  }

  // Static members
  static const String elementName = "Playlist";

  // Public members
  String name;
  double volumeFactor = 1.0;
  SoundSampleList sampleList;

  // Private members
}