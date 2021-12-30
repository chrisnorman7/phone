import 'dart:async';

import '../../../enumerations.dart';
import '../../../main_loop.dart';
import '../label.dart';

/// The type for the [Widget.onActivate] function.
typedef OnActivateCallback = Future<void> Function(MainLoop mainLoop);

/// Provides the [Widget] class.

/// The base class for all widgets.
class Widget {
  /// Create an instance.
  const Widget(
      {required this.label, this.onActivate, this.handledKeys = const {}});

  /// The function that will return the label for this widget.
  final LabelType label;

  /// The function to be called when this widget is activated.
  ///
  /// If this value is `null`, then it will not be possible to activate this
  /// widget.
  final OnActivateCallback? onActivate;

  /// The key events that this widget will handle.
  final Map<KeyEvent, OnActivateCallback> handledKeys;
}
