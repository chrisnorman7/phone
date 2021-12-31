/// Provides the [MainPage] class.
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';
import 'help_page.dart';
import 'settings_page.dart';

/// The main page.
class MainPage extends WidgetPage {
  /// Create an instance.
  MainPage()
      : super(
            label: label('Main Menu'),
            widgets: [
              Widget(
                  label: label('Settings'),
                  onActivate: (mainLoop) =>
                      mainLoop.pushPage(SettingsPage(mainLoop.options))),
              Widget(
                  label: label('Key Descriptions'),
                  onActivate: (mainLoop) => mainLoop.pushPage(HelpPage()))
            ],
            loggerName: 'Main Menu');
}
