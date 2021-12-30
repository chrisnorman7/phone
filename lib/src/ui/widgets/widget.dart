import '../../../main_loop.dart';
import '../label.dart';

/// Provides the [Widget] class.

/// The base class for all widgets.
class Widget {
  /// Create an instance.
  const Widget({required this.label, this.onActivate});

  /// The function that will return the label for this widget.
  final LabelType label;

  /// The function to be called when this widget is activated.
  ///
  /// If this value is `null`, then it will not be possible to activate this
  /// widget.
  final void Function(MainLoop mainLoop)? onActivate;
}
