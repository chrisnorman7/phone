// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emojis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Emoji _$EmojiFromJson(Map<String, dynamic> json) => Emoji(
      name: json['name'] as String,
      characters: json['characters'] as String,
      categoryName: json['category_name'] as String,
      subcategoryName: json['subcategory_name'] as String,
      keywords: (json['en_keywords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      ttsDescription: json['en_tts_description'] as String?,
      qualification: json['qualification'] as String,
    );

Map<String, dynamic> _$EmojiToJson(Emoji instance) => <String, dynamic>{
      'characters': instance.characters,
      'name': instance.name,
      'category_name': instance.categoryName,
      'subcategory_name': instance.subcategoryName,
      'en_keywords': instance.keywords,
      'en_tts_description': instance.ttsDescription,
      'qualification': instance.qualification,
    };
