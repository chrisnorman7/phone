/// Provides the [speechSystems] list.
import 'speech_configuration_value.dart';
import 'speech_system.dart';

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
          minValue: 60, defaultValue: 175, maxValue: 5000),
      extraArguments: ['-z']),
];
