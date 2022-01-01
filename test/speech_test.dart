import 'package:phone/speech.dart';
import 'package:phone/src/json/phone_options.dart';
import 'package:test/test.dart';

import 'common.dart';

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
          await engine.speak(text: 'Hello world.', substitutions: {});
          expect(engine.utterances.length, 1);
          var utterance = engine.utterances.first;
          expect(utterance.interrupt, isTrue);
          expect(utterance.text, 'Hello world.');
          await engine.speak(
              text: 'Testing.', substitutions: {}, interrupt: false);
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
