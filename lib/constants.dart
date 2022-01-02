/// Provides constants for use in the program.
import 'dart:convert';
import 'dart:io';

/// The directory where log files are stored.
final logDirectory = Directory('logs');

/// The json encoder to be used everywhere.
const jsonEncoder = JsonEncoder.withIndent('  ');
