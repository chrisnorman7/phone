// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneNumber _$PhoneNumberFromJson(Map<String, dynamic> json) => PhoneNumber(
      number: json['number'] as String,
      numberType: json['numberType'] as String,
    );

Map<String, dynamic> _$PhoneNumberToJson(PhoneNumber instance) =>
    <String, dynamic>{
      'number': instance.number,
      'numberType': instance.numberType,
    };

EmailAddress _$EmailAddressFromJson(Map<String, dynamic> json) => EmailAddress(
      address: json['address'] as String,
      addressType: json['addressType'] as String,
    );

Map<String, dynamic> _$EmailAddressToJson(EmailAddress instance) =>
    <String, dynamic>{
      'address': instance.address,
      'addressType': instance.addressType,
    };

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      firstName: json['firstName'] as String,
      surname: json['surname'] as String? ?? '',
      title: json['title'] as String? ?? '',
      phoneNumbers: (json['phoneNumbers'] as List<dynamic>?)
          ?.map((e) => PhoneNumber.fromJson(e as Map<String, dynamic>))
          .toList(),
      emailAddresses: (json['emailAddresses'] as List<dynamic>?)
          ?.map((e) => EmailAddress.fromJson(e as Map<String, dynamic>))
          .toList(),
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      website: json['website'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      groups:
          (json['groups'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'surname': instance.surname,
      'title': instance.title,
      'phoneNumbers': instance.phoneNumbers,
      'emailAddresses': instance.emailAddresses,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'website': instance.website,
      'notes': instance.notes,
      'groups': instance.groups,
    };

ContactList _$ContactListFromJson(Map<String, dynamic> json) => ContactList(
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContactListToJson(ContactList instance) =>
    <String, dynamic>{
      'contacts': instance.contacts,
    };
