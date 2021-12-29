/// Provides the [KeyMap] class.
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../../enumerations.dart';

part 'key_map.g.dart';

/// The key map class.
///
/// Instances of this class define which keys are handled.
@JsonSerializable()
class KeyMap {
  /// Create an instance.
  KeyMap(this.keys);

  /// Create an instance from a JSON object.
  factory KeyMap.fromJson(Map<String, dynamic> json) => _$KeyMapFromJson(json);

  /// The location for keymap files.
  static File keyMapFile = File('keymap.json');

  /// The keys to use.
  final Map<String, KeyEvent> keys;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$KeyMapToJson(this);
}
