/// Provides the [speechSystems] list.
import 'speech_configuration_value.dart';
import 'speech_system.dart';

/// The festival speech system.
class _SpeechSystemFestival extends SpeechSystem {
  /// Create an instance.
  const _SpeechSystemFestival()
      : super(
            executableName: 'festival',
            name: 'Festival',
            pitchConfiguration: const SpeechConfigurationValue(
                minValue: 0, defaultValue: 0, maxValue: 0),
            rateConfiguration: const SpeechConfigurationValue(
                minValue: 0, defaultValue: 0, maxValue: 0),
            afterSpeech: '")',
            beforeSpeech: '(SayText "');

  /// Escape quotation marks.
  @override
  String translateText(String text) => text.replaceAll('"', r'\"');
}

/// All the speech systems that are supported.
const speechSystems = <SpeechSystem>[
  SpeechSystem(
      name: 'espeak-ng',
      executableName: 'espeak-ng',
      pitchArgument: '-p',
      pitchConfiguration:
          SpeechConfigurationValue(minValue: 0, defaultValue: 50, maxValue: 99),
      rateArgument: '-s',
      rateConfiguration: SpeechConfigurationValue(
          minValue: 10, defaultValue: 175, maxValue: 400),
      extraArguments: ['-z']),
  _SpeechSystemFestival(),
];
