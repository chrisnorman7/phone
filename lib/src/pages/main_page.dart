import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';
import 'contact_list_page.dart';
import 'key_describer_page.dart';
import 'log_viewer_page.dart';
import 'settings_page.dart';

/// The main page.
class MainPage extends WidgetPage {
  /// Create an instance.
  MainPage()
      : super(
            label: label('Main Menu'),
            widgets: [
              Widget(
                  label: label('Contacts'),
                  onActivate: (mainLoop) =>
                      mainLoop.pushPage(ContactListPage(mainLoop.contactList))),
              Widget(
                  label: label('Settings'),
                  onActivate: (mainLoop) =>
                      mainLoop.pushPage(SettingsPage(mainLoop.options))),
              Widget(
                  label: label('Key Descriptions'),
                  onActivate: (mainLoop) =>
                      mainLoop.pushPage(KeyDescriberPage())),
              Widget(
                  label: label('View log files'),
                  onActivate: (mainLoop) => mainLoop.pushPage(LogViewerPage())),
            ],
            loggerName: 'Main Menu');
}
