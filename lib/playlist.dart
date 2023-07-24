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
    , volumeFactor = double.tryParse(element.getAttribute("volume_factor") ?? "0.0") ?? 0.0
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

  // Comparison

  @override bool operator ==(Object other)
  {
    if (other is! Playlist) {
      return false;
    }
    Playlist cmp = other as Playlist;
    if (name != cmp.name) {
      return false;
    }
    if (volumeFactor != cmp.volumeFactor){
      return false;
    }
    if (sampleList.length != cmp.sampleList.length) {
      return false;
    }
    for(int i = 0; i < sampleList.length; ++i){
      if (sampleList[i] != cmp.sampleList[i]) return false;
    }
    return true;
  }

  // Saving/Loading
  xml.XmlElement saveToXmlElement()
  {
    xml.XmlElement pl = xml.XmlElement(xml.XmlName(Playlist.elementName));
    pl.setAttribute("title", name);
    pl.setAttribute("volume_factor", volumeFactor.toString());
    for(final ss in sampleList) {
      xml.XmlElement ssElement = ss.saveToXmlElement();
      pl.children.add(ssElement);
    }

    return pl;
  }
}