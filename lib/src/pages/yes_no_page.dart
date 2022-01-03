/// Provides the [YesNoPage] class.
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';

/// A page with 2 options.
class YesNoPage extends WidgetPage {
  /// Create an instance.
  YesNoPage({
    required MainLoopCallback yesCallback,
    required MainLoopCallback noCallback,
    required String question,
    String yesTitle = 'Yes',
    String noTitle = 'No',
  }) : super(label: label(question), widgets: [
          Widget(label: label(yesTitle), onActivate: yesCallback),
          Widget(
            label: label(noTitle),
            onActivate: noCallback,
          )
        ]);
}
