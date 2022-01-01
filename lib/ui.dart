/// Exports all UI classes and functions.
library ui;

import 'dart:io';

import 'enumerations.dart';

export 'src/ui/input_handler.dart';
export 'src/ui/label.dart';
export 'src/ui/widget_page.dart';
export 'src/ui/widgets/widget.dart';

/// The new line character to use in key maps.
final newLineChar = Platform.isWindows ? '\r' : '\n';

/// The default key map to use.
final defaultKeymap = {
  '.': KeyEvent.mode,
  '0': KeyEvent.key0,
  '1': KeyEvent.key7,
  '2': KeyEvent.key8,
  '3': KeyEvent.key9,
  '4': KeyEvent.key4,
  '5': KeyEvent.key5,
  '6': KeyEvent.key6,
  '7': KeyEvent.key1,
  '8': KeyEvent.key2,
  '9': KeyEvent.key3,
  '/': KeyEvent.left,
  '*': KeyEvent.right,
  '-': KeyEvent.backspace,
  '+': KeyEvent.cancel,
  newLineChar: KeyEvent.enter
};
