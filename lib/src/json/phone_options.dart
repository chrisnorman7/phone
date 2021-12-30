/// Provides the [PhoneOptions] class.
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../../enumerations.dart';

part 'phone_options.g.dart';

/// The options for this application.
@JsonSerializable()
class PhoneOptions {
  /// Create an instance.
  PhoneOptions(
      {required this.newLineChar,
      required this.speechSystemName,
      required this.keyMap,
      this.speechSystemSpeed,
      this.navigationModeSticky = true});

  /// Create an instance from a JSON object.
  factory PhoneOptions.fromJson(Map<String, dynamic> json) =>
      _$PhoneOptionsFromJson(json);

  /// The file where options are stored.
  static File optionsFile = File('options.json');

  /// The new line character which should trigger [KeyEvent.enter].
  String newLineChar;

  /// The name of the speech system to use.
  String speechSystemName;

  /// The speech speed as a percentage.
  ///
  /// If this value is `null`, then the default speed for the selected speech
  /// system will be used.
  int? speechSystemSpeed;

  /// The keys to use.
  final Map<String, KeyEvent> keyMap;

  /// Whether ot not information mode should be sticky.
  bool navigationModeSticky;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$PhoneOptionsToJson(this);
}
