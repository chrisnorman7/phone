/// Provides the [SettingsPage] class.
import 'dart:convert';

import '../../enumerations.dart';
import '../../main_loop.dart';
import '../json/phone_options.dart';
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';
import 'speech_systems_page.dart';

/// Change the speech rate.
Future<void> _changeSpeechRate(MainLoop mainLoop, int difference) async {
  var rate = mainLoop.options.speechSystemRate ??
      mainLoop.speechEngine.system.rateConfiguration.defaultValue;
  rate += difference;
  final minRate = mainLoop.speechEngine.system.rateConfiguration.minValue;
  final maxRate = mainLoop.speechEngine.system.rateConfiguration.maxValue;
  if (rate < minRate) {
    rate = minRate;
  } else if (rate > maxRate) {
    rate = maxRate;
  }
  mainLoop.options.speechSystemRate = rate;
  mainLoop.speechEngine.rate = rate;
  await mainLoop.speechEngine.speak('Rate $rate.');
}

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
            if (options.speechSystemRate == null) {
              speed = 'Default';
            } else {
              speed = '${options.speechSystemRate}{';
            }
            return 'Speech speed: $speed';
          },
          handledKeys: {
            KeyEvent.key2: (mainLoop) => _changeSpeechRate(mainLoop, 5),
            KeyEvent.key8: (mainLoop) => _changeSpeechRate(mainLoop, -5),
            KeyEvent.key5: (mainLoop) async {
              options.speechSystemRate = null;
              mainLoop.speechEngine.rate =
                  mainLoop.speechEngine.system.rateConfiguration.defaultValue;
              await mainLoop.speechEngine.speak('Default.');
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
