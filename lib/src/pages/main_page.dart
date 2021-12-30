/// Provides the [MainPage] class.
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';

/// The main page.
class MainPage extends WidgetPage {
  /// Create an instance.
  MainPage()
      : super(
            label: label('Main Menu'),
            widgets: [Widget(label: label('Nothing yet'))]);
}
