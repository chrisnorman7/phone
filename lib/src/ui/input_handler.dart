/// Provides the [InputHandler] class.
import '../../enumerations.dart';
import '../../main_loop.dart';

/// A class for handling input.
abstract class InputHandler {
  /// Handle input.
  Future<void> handleKeyEvent(KeyEvent event, MainLoop mainLoop);

  /// The function to call when an object is pushed onto a [MainLoop] stack.
  Future<void> onPush(MainLoop mainLoop);

  /// The function to call when this handler is popped from a [MainLoop] stack.
  Future<void> onPop(MainLoop mainLoop);

  /// The function to be called when this handler is revealed.
  ///
  /// This function is called when a page that is covering it in a [MainLoop]
  /// stack is popped.
  Future<void> onReveal(MainLoop mainLoop, InputHandler covering);
}
