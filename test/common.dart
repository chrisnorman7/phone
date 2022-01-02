/// Provides common classes used by all tests.
import 'package:phone/emojis.dart';
import 'package:phone/main_loop.dart';
import 'package:phone/speech.dart';
import 'package:phone/src/json/contacts.dart';
import 'package:phone/src/json/phone_options.dart';
import 'package:phone/ui.dart';
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
  Future<void> speak(
      {required String text,
      required Map<String, String> substitutions,
      bool interrupt = true}) async {
    final utterance = SpeechUtterance(text: text, interrupt: interrupt);
    utterances.add(utterance);
  }

  /// Method for testing speech utterances.
  ///
  /// This method uses the [expect] function to ensure that:
  /// * The number of [utterances] is [length].
  /// * The last [SpeechUtterance] has an interrupt value of [interrupt].
  /// * The text of the last [SpeechUtterance] matches [text].
  void expectUtterance(
      {required int length, required bool interrupt, required dynamic text}) {
    expect(utterances.length, length);
    final utterance = utterances.last;
    expect(utterance.interrupt, interrupt);
    expect(utterance.text, text);
  }
}

/// Empty phone options.
class DummyPhoneOptions extends PhoneOptions {
  /// Create an instance.
  DummyPhoneOptions()
      : super(
            keyMap: defaultKeymap,
            speechSystemName: speechSystems.first.name,
            newLineChar: newLineChar);
}

/// The default main loop.
class DummyMainLoop extends MainLoop {
  /// Create an instance.
  DummyMainLoop()
      : super(
            emojis: getEmojis(),
            options: DummyPhoneOptions(),
            speechEngine: DummySpeechEngine(),
            contactList: ContactList());
}
