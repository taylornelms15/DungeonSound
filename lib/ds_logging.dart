import 'dart:developer' as developer;
import "package:logging/logging.dart";

enum LType {
  debug,
  buttonPress,
}

void logDebug(String message, LType type)
{
  developer.log(message,
      name: type.name,
      time: DateTime.timestamp(),
      level: Level.FINE.value);
}

void logInfo(String message, LType type)
{
  developer.log(message,
    name: type.name,
    time: DateTime.timestamp(),
    level: Level.INFO.value);
}

void logWarn(String message, LType type)
{
  developer.log(message,
    name: type.name,
    time: DateTime.timestamp(),
    level: Level.WARNING.value);
}

void logError(String message, LType type)
{
  developer.log(message,
      name: type.name,
      time: DateTime.timestamp(),
      level: Level.SEVERE.value);
}

