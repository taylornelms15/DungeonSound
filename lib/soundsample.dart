/// @brief Class for storing records of playable audio
///
/// The SoundSample should record everything that can be set by a user
/// when designing a playlist, but is not meant to be reflective
/// of any current playback status on its own.
class SoundSample
{
  // Public members
  String name = "";
  double start_timestamp = 0.0;
  double end_timestamp = 0.0;
  double volume_factor = 1.0;

  // Private members
  String? _resource_url;
  double _total_time = 0.0;
  double get _total_playable_time => end_timestamp = start_timestamp;
}
