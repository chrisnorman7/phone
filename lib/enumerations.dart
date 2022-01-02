/// Provides various enumerations used by the program.
library enumerations;

import 'src/ui/widget_page.dart';

/// The various keys supported by the program.
enum KeyEvent {
  /// Key 0.
  key0,

  /// Key 1.
  key1,

  /// Key 2.
  key2,

  /// Key 3.
  key3,

  /// Key 4.
  key4,

  /// Key 5.
  key5,

  /// Key 6.
  key6,

  /// Key 7.
  key7,

  /// Key 8.
  key8,

  /// Key 9.
  key9,

  /// Left arrow.
  left,

  /// Right arrow.
  right,

  /// Enter key.
  enter,

  /// Cancel.
  cancel,

  /// Backspace.
  backspace,

  /// Change modes.
  mode,
}

/// The various navigation modes used by [WidgetPage] instances.
enum NavigationMode {
  /// Standard.
  ///
  /// In this mode, keys act as you'd expect.
  standard,

  /// Information.
  ///
  /// In this mode, the 0 key speaks the time, ETC.
  info,
}

/// The possible typing modes.
enum TypingMode {
  /// Lower case letters.
  lowerCase,

  /// Upper case letters.
  upperCase,

  /// Number entry.
  numbers,
}
