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
      : _pitch = pitch ?? system.pitchConfiguration.defaultValue,
        _rate = rate ?? system.rateConfiguration.defaultValue,
        logger = Logger('Speech Engine <${system.name}>');

  /// The speech system to use.
  final SpeechSystem system;

  /// The logger to use.
  final Logger logger;

  /// The current speech pitch.
  final int _pitch;

  /// The speech rate.
  final int _rate;

  /// The process to use.
  ///
  /// This value will be `null` before the speech system has been initialised.
  Process? _process;

  /// Reset the speech process.
  Future<Process> _reset() async {
    final process = await Process.start(system.executableName, [
      system.pitchArgument,
      _pitch.toString(),
      system.rateArgument,
      _rate.toString(),
      ...system.extraArguments
    ]);
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
