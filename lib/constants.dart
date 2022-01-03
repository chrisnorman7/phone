/// Provides constants for use in the program.
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

import 'src/json/contacts.dart';

/// The directory where log files are stored.
final logDirectory = Directory('logs');

/// The json encoder to be used everywhere.
const jsonEncoder = JsonEncoder.withIndent('  ');

/// The default contact types.
///
/// These entries will be used when adding [EmailAddress]es and [PhoneNumber]s.
const contactTypes = [
  'Home',
  'Personal',
  'Work',
  'Office',
  'Other',
];

/// The date formatter to use for showing the full date and time.
final dateTimeFormatter = DateFormat();

/// A formatter for showing only dates.
final dateFormatter = DateFormat('EEEE d MMMM y');
