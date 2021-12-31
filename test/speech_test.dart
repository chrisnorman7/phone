import 'package:phone/speech.dart';
import 'package:phone/src/json/phone_options.dart';
import 'package:test/test.dart';

/// A speech utterance.
class SpeechUtterance {
  /// Create an instance.
  const SpeechUtterance({required this.text, required this.interrupt});

  /// The string to speak.
  final String text;

  /// Whether or not to interrupt.
  final bool interrupt;
}

/// A speech engine that stores strings.
class DummySpeechEngine extends SpeechEngine {
  /// Create an instance.
  DummySpeechEngine()
      : utterances = [],
        super(system: speechSystems.first);

  /// The strings spoken so far.
  final List<SpeechUtterance> utterances;

  /// Store the speech string.
  @override
  Future<void> speak(String text, Map<String, String> substitutions,
      {bool interrupt = true}) async {
    final utterance = SpeechUtterance(text: text, interrupt: interrupt);
    utterances.add(utterance);
  }
}

void main() {
  group(
    'Speech Tests',
    () {
      final engine = DummySpeechEngine();
      test(
        'Initialisation',
        () {
          expect(engine.system, speechSystems.first);
          expect(engine.utterances, isEmpty);
        },
      );
      test(
        'Speaking',
        () async {
          engine.utterances.clear();
          await engine.speak('Hello world.', {});
          expect(engine.utterances.length, 1);
          var utterance = engine.utterances.first;
          expect(utterance.interrupt, isTrue);
          expect(utterance.text, 'Hello world.');
          await engine.speak('Testing.', {}, interrupt: false);
          expect(engine.utterances.length, 2);
          utterance = engine.utterances.last;
          expect(utterance.interrupt, isFalse);
          expect(utterance.text, 'Testing.');
        },
      );
      test(
        'Substitutions',
        () async {
          for (final entry in defaultSpeechDictionary.entries) {
            final text =
                engine.substituteText(entry.key, defaultSpeechDictionary);
            expect(text, ' ${entry.value} ',
                reason: 'Should substitute ${entry.key}` for `${entry.value}`');
          }
        },
      );
    },
  );
}
