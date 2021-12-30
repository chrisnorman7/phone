/// Provides the [SettingsPage] class.
import 'dart:convert';
import 'dart:math';

import '../../enumerations.dart';
import '../json/phone_options.dart';
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';
import 'speech_systems_page.dart';

/// A menu for configuring the OS.
class SettingsPage extends WidgetPage {
  /// Create an instance.
  SettingsPage(PhoneOptions options)
      : super(
            label: label('Settings'),
            widgets: [],
            onCancel: (mainLoop) => mainLoop.popPage(),
            loggerName: 'Settings Page') {
    widgets.addAll([
      Widget(
          label: () => 'Speech synthesizer: ${options.speechSystemName}',
          onActivate: (mainLoop) =>
              mainLoop.pushPage(SpeechSystemsPage(options))),
      Widget(
          label: () {
            final String speed;
            if (options.speechSystemSpeed == null) {
              speed = 'Default';
            } else {
              speed = '${options.speechSystemSpeed}{%';
            }
            return 'Speech speed: $speed';
          },
          onActivate: (mainLoop) async {
            options.speechSystemSpeed = null;
            await mainLoop.speechEngine.speak('Default.');
          },
          handledKeys: {
            KeyEvent.key2: (mainLoop) async {
              var rate = options.speechSystemSpeed ?? 50;
              rate = min(100, rate + 5);
              options.speechSystemSpeed = rate;
              await mainLoop.speechEngine.speak('$rate%');
            },
            KeyEvent.key8: (mainLoop) async {
              var rate = options.speechSystemSpeed ?? 50;
              rate = max(0, rate - 5);
              options.speechSystemSpeed = rate;
              await mainLoop.speechEngine.speak('$rate%');
            }
          }),
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
          }),
    ]);
  }
}
