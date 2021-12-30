// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneOptions _$PhoneOptionsFromJson(Map<String, dynamic> json) => PhoneOptions(
      newLineChar: json['newLineChar'] as String,
      speechSystemName: json['speechSystemName'] as String,
      keyMap: (json['keyMap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, $enumDecode(_$KeyEventEnumMap, e)),
      ),
    );

Map<String, dynamic> _$PhoneOptionsToJson(PhoneOptions instance) =>
    <String, dynamic>{
      'newLineChar': instance.newLineChar,
      'speechSystemName': instance.speechSystemName,
      'keyMap':
          instance.keyMap.map((k, e) => MapEntry(k, _$KeyEventEnumMap[e])),
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
  KeyEvent.mode: 'mode',
};
