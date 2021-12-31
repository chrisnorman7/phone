/// Provides the [SpeechSystem] class.
library speech_system;

import 'speech_configuration_value.dart';

/// A speech system.
class SpeechSystem {
  /// Create a system.
  const SpeechSystem(
      {required this.name,
      required this.executableName,
      required this.pitchConfiguration,
      required this.rateConfiguration,
      this.pitchArgument,
      this.rateArgument,
      this.beforeSpeech = '',
      this.afterSpeech = '',
      this.extraArguments = const []});

  /// The name of this system.
  final String name;

  /// The name of the executable that must be called.
  final String executableName;

  /// The command line switch that changes the pitch.
  final String? pitchArgument;

  /// The pitch configuration.
  final SpeechConfigurationValue pitchConfiguration;

  /// The command line switch that allows configuring speech rate.
  final String? rateArgument;

  /// The rate configuration.
  final SpeechConfigurationValue rateConfiguration;

  /// The string to put before the text to speak.
  final String beforeSpeech;

  /// The string to append to the speech text.
  final String afterSpeech;

  /// Extra arguments to pass to the executable.
  final List<String> extraArguments;

  /// Return [text] as a string suitable for the synthesizer.
  ///
  /// This function is used by Festival for example, where quotation marks need
  /// to be escaped.
  String translateText(String text) => text;
}
