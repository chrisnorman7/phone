/// Provides the [SpeechConfigurationValue] class.
library speech_configuration_value;

/// The value of a speech configuration parameter.
class SpeechConfigurationValue {
  /// Create an instance.
  const SpeechConfigurationValue(
      {required this.minValue,
      required this.defaultValue,
      required this.maxValue});

  /// The minimum value.
  final int minValue;

  /// The maximum value.
  final int maxValue;

  /// The default value.
  final int defaultValue;
}
