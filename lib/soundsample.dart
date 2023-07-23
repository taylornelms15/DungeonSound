import 'package:xml/xml.dart' as xml;

/// @brief Class for storing records of playable audio
///
/// The SoundSample should record everything that can be set by a user
/// when designing a playlist, but is not meant to be reflective
/// of any current playback status on its own.
class SoundSample
{
  // Constructors
  SoundSample()
    : name = "New SoundSample"
  ;

  SoundSample.fromXmlElement(xml.XmlElement element)
    : assert(element.name.toString() == SoundSample.elementName)
    , name = element.getAttribute("title")!
    , _resourceUrl = element.getAttribute("resource_url")
    , startTimestamp = double.tryParse(element.getAttribute("start_timestamp") ?? "0.0") ?? 0.0
    , endTimestamp = double.tryParse(element.getAttribute("end_timestamp") ?? "0.0") ?? 0.0
    , volumeFactor = double.tryParse(element.getAttribute("volume_factor") ?? "0.0") ?? 0.0
  {
    if (_resourceUrl != null) {
      //TODO: get time data from the resource_url
    }
  }

  // Static members
  static const String elementName = "SoundSample";

  // Public members
  String name;
  double startTimestamp = 0.0;
  double endTimestamp = 0.0;
  double volumeFactor = 1.0;

  // Private members
  String? _resourceUrl;
  double _totalTime = 0.0;
  double get _totalPlayableTime => endTimestamp = startTimestamp;
}
