/// Provides the [SettingsPage] class.
import 'dart:convert';

import '../json/phone_options.dart';
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';

/// A menu for configuring the OS.
class SettingsPage extends WidgetPage {
  /// Create an instance.
  SettingsPage(PhoneOptions options)
      : super(label: label('Settings'), widgets: []) {
    widgets.addAll([
      Widget(
          label: () => 'Return to navigation mode automatically: '
              '${options.navigationModeSticky ? "on" : "off"}',
          onActivate: (mainLoop) async {
            options.navigationModeSticky = !options.navigationModeSticky;
            await showCurrentWidget(mainLoop);
          }),
      Widget(
          label: label('Save'),
          onActivate: (mainLoop) async {
            final json = options.toJson();
            PhoneOptions.optionsFile
                .writeAsStringSync(JsonEncoder.withIndent('  ').convert(json));
            await mainLoop.popPage();
          }),
      Widget(
          label: label('Cancel'),
          onActivate: (mainLoop) async {
            await mainLoop.popPage();
          })
    ]);
  }
}
