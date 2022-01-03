/// Provides the [YesNoPage] class.
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';

/// The default yes label.
String defaultYesLabel() => 'yes';

/// The default no label.
String defaultNoLabel() => 'No';

/// The default question.
String defaultQuestion() => 'Are you sure?';

/// A page with 2 options.
class YesNoPage extends WidgetPage {
  /// Create an instance.
  YesNoPage({
    required this.yesCallback,
    required this.noCallback,
    this.yesLabel = defaultYesLabel,
    this.noLabel = defaultNoLabel,
    LabelType question = defaultQuestion,
  }) : super(label: question, widgets: [
          Widget(label: yesLabel, onActivate: yesCallback),
          Widget(
            label: noLabel,
            onActivate: noCallback,
          )
        ]);

  /// The callback when "yes" is selected.
  final MainLoopCallback yesCallback;

  /// The callback for when "no" is selected.
  final MainLoopCallback noCallback;

  /// The label for the "yes" widget.
  final LabelType yesLabel;

  /// The label for the "no" widget.
  final LabelType noLabel;
}
