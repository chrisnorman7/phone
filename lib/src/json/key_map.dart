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
  KeyMap(
      {this.keys = const {
        '.': KeyEvent.mode,
        '0': KeyEvent.key0,
        '1': KeyEvent.key1,
        '2': KeyEvent.key2,
        '3': KeyEvent.key3,
        '4': KeyEvent.key4,
        '5': KeyEvent.key5,
        '6': KeyEvent.key6,
        '7': KeyEvent.key7,
        '8': KeyEvent.key8,
        '9': KeyEvent.key9,
        '/': KeyEvent.left,
        '*': KeyEvent.right,
        '-': KeyEvent.backspace,
        '+': KeyEvent.cancel,
        '\r': KeyEvent.enter
      }});

  /// Create an instance from a JSON object.
  factory KeyMap.fromJson(Map<String, dynamic> json) => _$KeyMapFromJson(json);

  /// The location for keymap files.
  static File keyMapFile = File('keymap.json');

  /// The keys to use.
  final Map<String, KeyEvent> keys;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$KeyMapToJson(this);
}
