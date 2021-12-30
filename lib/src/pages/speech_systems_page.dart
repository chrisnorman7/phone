/// Provides the [SpeechSystemsPage] class.
import '../../speech.dart';
import '../json/phone_options.dart';
import '../speech/speech_systems.dart';
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';

/// A menu for selecting a new speech synthesizer.
class SpeechSystemsPage extends WidgetPage {
  /// Create an instance.
  SpeechSystemsPage(PhoneOptions options)
      : super(
            label: label('Speech Synthesizers'),
            widgets: [
              for (final system in speechSystems)
                Widget(
                    label: label(system.name),
                    onActivate: (mainLoop) async {
                      if (system.name != options.speechSystemName) {
                        options.speechSystemName = system.name;
                        mainLoop.speechEngine.shutdown();
                        mainLoop.speechEngine = SpeechEngine(system: system);
                      }
                      await mainLoop.popPage();
                    })
            ],
            onCancel: (mainLoop) => mainLoop.popPage());
}
