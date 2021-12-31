/// Provides the [PhoneOptions] class.
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../../enumerations.dart';
import '../speech/speech_system.dart';

part 'phone_options.g.dart';

/// The options for this application.
@JsonSerializable()
class PhoneOptions {
  /// Create an instance.
  PhoneOptions(
      {required this.newLineChar,
      required this.speechSystemName,
      required this.keyMap,
      Map<String, int>? speechSystemRates,
      this.navigationModeSticky = true})
      : speechSystemRates = speechSystemRates ?? {};

  /// Create an instance from a JSON object.
  factory PhoneOptions.fromJson(Map<String, dynamic> json) =>
      _$PhoneOptionsFromJson(json);

  /// The file where options are stored.
  static File optionsFile = File('options.json');

  /// The new line character which should trigger [KeyEvent.enter].
  String newLineChar;

  /// The name of the speech system to use.
  String speechSystemName;

  /// The speech speed.
  ///
  /// If this value is `null`, then the default speed for the selected speech
  /// system will be used.
  final Map<String, int> speechSystemRates;

  /// The keys to use.
  final Map<String, KeyEvent> keyMap;

  /// Whether ot not information mode should be sticky.
  bool navigationModeSticky;

  /// Get the speech rate for the [SpeechSystem] with the given [systemName].
  int? getSpeechRate(String systemName) => speechSystemRates[systemName];

  /// Set the speech rate for the [SpeechSystem] with the given [systemName].
  void setSpeechRate(String systemName, [int? rate]) {
    if (rate == null) {
      speechSystemRates.remove(systemName);
    } else {
      speechSystemRates[systemName] = rate;
    }
  }

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$PhoneOptionsToJson(this);
}
