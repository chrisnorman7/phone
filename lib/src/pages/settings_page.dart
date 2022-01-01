/// Provides the [SettingsPage] class.
import 'dart:convert';

import 'package:logging/logging.dart';

import '../../enumerations.dart';
import '../../main_loop.dart';
import '../json/phone_options.dart';
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';
import 'log_level_page.dart';
import 'speech_systems_page.dart';

/// Change the speech rate.
Future<void> _changeSpeechRate(MainLoop mainLoop, int difference) async {
  var rate =
      mainLoop.options.getSpeechRate(mainLoop.speechEngine.system.name) ??
          mainLoop.speechEngine.system.rateConfiguration.defaultValue;
  rate += difference;
  final minRate = mainLoop.speechEngine.system.rateConfiguration.minValue;
  final maxRate = mainLoop.speechEngine.system.rateConfiguration.maxValue;
  if (rate < minRate) {
    rate = minRate;
  } else if (rate > maxRate) {
    rate = maxRate;
  }
  mainLoop.options.setSpeechRate(mainLoop.speechEngine.system.name, rate);
  mainLoop.speechEngine.rate = rate;
  await mainLoop.speak('Rate $rate.');
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
            final speechRate = options.getSpeechRate(options.speechSystemName);
            if (speechRate == null) {
              speed = 'Default';
            } else {
              speed = speechRate.toString();
            }
            return 'Speech speed: $speed';
          },
          handledKeys: {
            KeyEvent.key2: (mainLoop) => _changeSpeechRate(mainLoop, 5),
            KeyEvent.key8: (mainLoop) => _changeSpeechRate(mainLoop, -5),
            KeyEvent.key5: (mainLoop) async {
              options.setSpeechRate(mainLoop.speechEngine.system.name);
              mainLoop.speechEngine.rate =
                  mainLoop.speechEngine.system.rateConfiguration.defaultValue;
              await mainLoop.speak('Default.');
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
          label: () => 'Log level: ${Logger.root.level.name}',
          onActivate: (mainLoop) => mainLoop.pushPage(LogLevelPage())),
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
