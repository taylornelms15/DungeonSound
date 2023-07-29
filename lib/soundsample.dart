import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:io';

/// @brief Class for storing records of playable audio
///
/// The SoundSample should record everything that can be set by a user
/// when designing a playlist, but is not meant to be reflective
/// of any current playback status on its own.
class SoundSample
{
  // Constructors
  SoundSample({String? name, double? startTimestamp, double? endTimestamp, double? volumeFactor})
    : name = name ?? "New SoundSample"
    , startTimestamp = startTimestamp ?? 0.0
    , endTimestamp = endTimestamp ?? 0.0
    , volumeFactor = volumeFactor ?? 1.0
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
      resourceUri = Uri.file(_resourceUrl!, windows: Platform.isWindows);
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
  Uri? resourceUri;

  // Private members
  String? _resourceUrl;
  double _totalTime = 0.0;
  double get _totalPlayableTime => endTimestamp = startTimestamp;

  void setResourceUrl(String url)
  {
    _resourceUrl = url;
    resourceUri = Uri.file(url, windows: Platform.isWindows);
  }

  // Comparison
  @override bool operator ==(Object other)
  {
    if (other is! SoundSample) {
      return false;
    }
    return (name == other.name &&
            startTimestamp == other.startTimestamp &&
            endTimestamp == other.endTimestamp &&
            volumeFactor == other.volumeFactor &&
            resourceUri == other.resourceUri);
  }

  // Saving/Loading
  xml.XmlElement saveToXmlElement()
  {
    xml.XmlElement ss = xml.XmlElement(xml.XmlName(SoundSample.elementName));

    ss.setAttribute("title", name);
    if (resourceUri != null) {
      ss.setAttribute("resource_url", resourceUri!.toFilePath());
    }
    ss.setAttribute("start_timestamp", startTimestamp.toString());
    ss.setAttribute("end_timestamp", endTimestamp.toString());
    ss.setAttribute("volume_factor", volumeFactor.toString());

    return ss;
  }
}
