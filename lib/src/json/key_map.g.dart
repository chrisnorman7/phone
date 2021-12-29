// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyMap _$KeyMapFromJson(Map<String, dynamic> json) => KeyMap(
      keys: (json['keys'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, $enumDecode(_$KeyEventEnumMap, e)),
          ) ??
          const {
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
            '\n': KeyEvent.enter
          },
    );

Map<String, dynamic> _$KeyMapToJson(KeyMap instance) => <String, dynamic>{
      'keys': instance.keys.map((k, e) => MapEntry(k, _$KeyEventEnumMap[e])),
    };

const _$KeyEventEnumMap = {
  KeyEvent.key0: 'key0',
  KeyEvent.key1: 'key1',
  KeyEvent.key2: 'key2',
  KeyEvent.key3: 'key3',
  KeyEvent.key4: 'key4',
  KeyEvent.key5: 'key5',
  KeyEvent.key6: 'key6',
  KeyEvent.key7: 'key7',
  KeyEvent.key8: 'key8',
  KeyEvent.key9: 'key9',
  KeyEvent.left: 'left',
  KeyEvent.right: 'right',
  KeyEvent.enter: 'enter',
  KeyEvent.cancel: 'cancel',
  KeyEvent.backspace: 'backspace',
};
