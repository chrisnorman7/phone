/// Provides classes relating to contacts.
import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';

import '../../constants.dart';

part 'contacts.g.dart';

/// A phone number for a [Contact].
@JsonSerializable()
class PhoneNumber {
  /// Create an instance.
  PhoneNumber({required this.number, required this.numberType});

  /// Create an instance from a JSON object.
  factory PhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberFromJson(json);

  /// The number to call.
  String number;

  /// The type of the [number].
  String numberType;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$PhoneNumberToJson(this);
}

/// An email address for a [Contact].
@JsonSerializable()
class EmailAddress {
  /// Create an instance.
  EmailAddress({required this.address, required this.addressType});

  /// Create an instance from a JSON object.
  factory EmailAddress.fromJson(Map<String, dynamic> json) =>
      _$EmailAddressFromJson(json);

  /// The address to use.
  String address;

  /// The type of this email address.
  String addressType;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$EmailAddressToJson(this);
}

/// A contact in a [ContactList].
@JsonSerializable()
class Contact {
  /// Create an instance.
  Contact({
    required this.firstName,
    this.surname = '',
    this.title = '',
    List<PhoneNumber>? phoneNumbers,
    List<EmailAddress>? emailAddresses,
    this.dateOfBirth,
    this.website = '',
    this.notes = '',
    List<String>? groups,
  })  : phoneNumbers = phoneNumbers ?? [],
        emailAddresses = emailAddresses ?? [],
        groups = groups ?? [];

  /// Create an instance from a JSON object.
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  /// The first name of the contact.
  String firstName;

  /// The surname for this contact.
  String surname;

  /// The title for the contact.
  String title;

  /// Get the full name of this contact.
  String get name {
    var result = firstName;
    if (surname.isNotEmpty) {
      result = '$result $surname';
    }
    return result;
  }

  /// The full name (including [title]) of this contact.
  String get fullName {
    if (title.isNotEmpty) {
      return '$title. $name';
    }
    return name;
  }

  /// The phone numbers for this contact.
  final List<PhoneNumber> phoneNumbers;

  /// Email addresses for this contact.
  final List<EmailAddress> emailAddresses;

  /// The date of birth for this contact.
  DateTime? dateOfBirth;

  /// The website for this contact.
  String website;

  /// Notes about this contact.
  String notes;

  /// The groups this contact is a member of.
  final List<String> groups;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

/// A class to hold a list of [Contact] instances.
@JsonSerializable()
class ContactList {
  /// Create an instance.
  ContactList({List<Contact>? contacts}) : contacts = contacts ?? [];

  /// Create an instance from a JSON object.
  factory ContactList.fromJson(Map<String, dynamic> json) =>
      _$ContactListFromJson(json);

  /// Load an instance.
  ///
  /// If [contactsFile] exists, then the instance will be loaded from that.
  /// Otherwise, a new instance will be created and returned.
  factory ContactList.load() {
    if (contactsFile.existsSync()) {
      logger.info('Loading contacts from ${contactsFile.path}.');
      final data = contactsFile.readAsStringSync();
      final json = jsonDecode(data) as Map<String, dynamic>;
      logger.info('Loaded JSON.');
      return ContactList.fromJson(json);
    }
    return ContactList();
  }

  /// The file where contacts are stored.
  static final contactsFile = File('contacts.json');

  /// The logger for this list.
  static final logger = Logger('Contacts List');

  /// The contacts in this contact list.
  final List<Contact> contacts;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ContactListToJson(this);

  /// Save the contacts list.
  void save() {
    final json = jsonEncoder.convert(this);
    contactsFile.writeAsStringSync(json);
  }
}
