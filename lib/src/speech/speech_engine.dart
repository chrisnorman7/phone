/// Provides the [SpeechEngine] class.
import 'dart:io';

import 'package:logging/logging.dart';

import '../../speech.dart';

/// A speech engine.
///
/// This class allows the queuing of speech utterances.
class SpeechEngine {
  /// Create an instance.
  SpeechEngine({required this.system, int? pitch, int? rate})
      : pitch = pitch ?? system.pitchConfiguration.defaultValue,
        rate = rate ?? system.rateConfiguration.defaultValue,
        logger = Logger('Speech Engine <${system.name}>');

  /// The speech system to use.
  final SpeechSystem system;

  /// The logger to use.
  final Logger logger;

  /// The current speech pitch.
  final int pitch;

  /// The speech rate.
  int rate;

  /// The process to use.
  ///
  /// This value will be `null` before the speech system has been initialised.
  Process? _process;

  /// Reset the speech process.
  Future<Process> _reset() async {
    final arguments = [...system.extraArguments];
    final pitchArgument = system.pitchArgument;
    if (pitchArgument != null) {
      arguments.addAll([
        pitchArgument,
        pitch.toString(),
      ]);
    }
    final rateArgument = system.rateArgument;
    if (rateArgument != null) {
      arguments.addAll([
        rateArgument,
        rate.toString(),
      ]);
    }
    final process = await Process.start(system.executableName, arguments);
    _process = process;
    logger.info('Reset.');
    return process;
  }

  /// Destroy this engine.
  ///
  /// This method kills the underlying process.
  void shutdown() {
    _process?.kill();
    _process = null;
  }

  /// Silence speech.
  Future<void> silence() async {
    shutdown();
    await _reset();
  }

  /// Enqueue an utterance.
  Future<void> enqueueText(String text) async {
    final process = _process ?? await _reset();
    process.stdin.writeln(text);
  }

  /// Speak something.
  Future<void> speak(String text, {bool interrupt = true}) async {
    logger.info('Speak "$text" interrupt: $interrupt.');
    if (interrupt) {
      await silence();
    }
    await enqueueText(text);
  }
}
