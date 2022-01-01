import 'package:phone/enumerations.dart';
import 'package:phone/main_loop.dart';
import 'package:phone/ui.dart';
import 'package:test/test.dart';

import 'common.dart';

/// An event received by [TestInputHandler].
class InputEvent {
  /// Create an instance.
  const InputEvent(this.event, this.mainLoop);

  /// The event which was received.
  final KeyEvent event;

  /// The main loop which was used.
  final MainLoop mainLoop;
}

/// A push event.
class PushEvent {
  /// Create an instance.
  const PushEvent(this.mainLoop);

  /// The main loop that was used.
  final MainLoop mainLoop;
}

/// A pop event.
class PopEvent {
  /// Create an instance.
  const PopEvent(this.mainLoop);

  /// The main loop that was used.
  final MainLoop mainLoop;
}

/// A reveal event.
class RevealEvent {
  /// Create an instance.
  const RevealEvent(this.mainLoop, this.covering);

  /// The main loop to use.
  final MainLoop mainLoop;

  /// The covering widget.
  final InputHandler covering;
}

void defaultOnPush(MainLoop mainLoop) => throw OnPush(mainLoop);
void defaultOnPop(MainLoop mainLoop) => throw OnPop(mainLoop);
void defaultOnReveal(MainLoop mainLoop, InputHandler covering) =>
    throw OnReveal(mainLoop, covering);

/// A test input handler.
class TestInputHandler implements InputHandler {
  /// Create an instance.
  TestInputHandler(
      {this.onPushFunc = defaultOnPush,
      this.onPopFunc = defaultOnPop,
      this.onRevealFunc = defaultOnReveal})
      : inputEvents = [],
        pushEvents = [],
        popEvents = [],
        revealEvents = [];

  /// What to do when this instance is pushed.
  final void Function(MainLoop mainLoop) onPushFunc;

  /// What to do when this instance is popped.
  final void Function(MainLoop mainLoop) onPopFunc;

  /// What to do when revealing this instance.
  final void Function(MainLoop mainLoop, InputHandler covering) onRevealFunc;

  /// Key events.
  final List<InputEvent> inputEvents;

  /// The push events.
  final List<PushEvent> pushEvents;

  /// The pop events.
  final List<PopEvent> popEvents;

  /// The reveal events.
  final List<RevealEvent> revealEvents;

  @override
  Future<void> handleKeyEvent(KeyEvent event, MainLoop mainLoop) async {
    inputEvents.add(InputEvent(event, mainLoop));
  }

  @override
  Future<void> onPush(MainLoop mainLoop) async {
    pushEvents.add(PushEvent(mainLoop));
    onPushFunc(mainLoop);
  }

  @override
  Future<void> onPop(MainLoop mainLoop) async {
    popEvents.add(PopEvent(mainLoop));
    onPopFunc(mainLoop);
  }

  @override
  Future<void> onReveal(MainLoop mainLoop, InputHandler covering) async {
    revealEvents.add(RevealEvent(mainLoop, covering));
    onRevealFunc(mainLoop, covering);
  }
}

/// Push.
class OnPush implements Exception {
  /// Create an instance.
  const OnPush(this.mainLoop);

  /// The main loop.
  final MainLoop mainLoop;
}

/// On pop.
class OnPop implements Exception {
  /// Create an instance.
  const OnPop(this.mainLoop);

  /// The main loop to use.
  final MainLoop mainLoop;
}

/// On reveal.
class OnReveal implements Exception {
  /// Create an instance.
  const OnReveal(this.mainLoop, this.covering);

  /// The main loop to use.
  final MainLoop mainLoop;

  /// The covering input handler.
  final InputHandler covering;
}

void main() {
  final mainLoop = DummyMainLoop();
  group(
    'TestInputHandler class',
    () {
      final inputHandler = TestInputHandler();
      test(
        'Initialisation',
        () {
          expect(inputHandler.inputEvents, isEmpty);
          expect(inputHandler.onPopFunc, defaultOnPop);
          expect(inputHandler.onPushFunc, defaultOnPush);
          expect(inputHandler.onRevealFunc, defaultOnReveal);
          expect(inputHandler.popEvents, isEmpty);
          expect(inputHandler.pushEvents, isEmpty);
          expect(inputHandler.revealEvents, isEmpty);
        },
      );
      test(
        '.onPush',
        () {
          expectLater(
              () => inputHandler.onPush(mainLoop),
              throwsA(predicate(
                (e) => e is OnPush && e.mainLoop == mainLoop,
              )));
        },
      );
      test(
        '.onPop',
        () {
          expectLater(
              () => inputHandler.onPop(mainLoop),
              throwsA(predicate(
                (e) => e is OnPop && e.mainLoop == mainLoop,
              )));
        },
      );
      test(
        '.onReveal',
        () {
          final covering = TestInputHandler();
          expectLater(
              () => inputHandler.onReveal(mainLoop, covering),
              throwsA(predicate(
                (e) =>
                    e is OnReveal &&
                    e.mainLoop == mainLoop &&
                    e.covering == covering,
              )));
        },
      );
    },
  );
  group(
    'InputHandler class',
    () {
      setUp(mainLoop.pages.clear);
      test(
        '.onPush',
        () async {
          final inputHandler = TestInputHandler(
            onPushFunc: (mainLoop) {
              assert(mainLoop.pages.isEmpty,
                  'Existing pages: ${mainLoop.pages.length}.');
            },
          );
          await mainLoop.pushPage(inputHandler);
          expect(inputHandler.popEvents, isEmpty);
          expect(inputHandler.revealEvents, isEmpty);
          expect(mainLoop.pages.length, 1);
          expect(mainLoop.pages.first, inputHandler);
          expect(inputHandler.pushEvents.length, 1);
          final event = inputHandler.pushEvents.first;
          expect(event.mainLoop, mainLoop);
          final handler = TestInputHandler(
            onPushFunc: (mainLoop) {
              assert(
                  mainLoop.pages.length == 1 &&
                      mainLoop.pages.first == inputHandler,
                  'Pages: ${mainLoop.pages.length}.');
            },
          );
          await mainLoop.pushPage(handler);
          expect(mainLoop.pages.length, 2);
          expect(mainLoop.pages.first, inputHandler);
          expect(mainLoop.pages.last, handler);
        },
      );
      test(
        'onPop',
        () async {
          final inputHandler = TestInputHandler(
              onPopFunc: (mainLoop) {
                assert(
                    mainLoop.pages.isEmpty, 'Pages: ${mainLoop.pages.length}.');
              },
              onPushFunc: (mainLoop) {},
              onRevealFunc: (mainLoop, covering) {});
          await mainLoop.pushPage(inputHandler);
          await mainLoop.popPage();
          expect(inputHandler.revealEvents, isEmpty);
          expect(inputHandler.pushEvents.length, 1);
          expect(inputHandler.popEvents.length, 1);
          var event = inputHandler.popEvents.first;
          expect(event.mainLoop, mainLoop);
          expect(mainLoop.pages, isEmpty);
          await mainLoop.pushPage(inputHandler);
          expect(inputHandler.pushEvents.length, 2);
          final handler = TestInputHandler(
              onPopFunc: (mainLoop) {
                assert(
                    mainLoop.pages.length == 1 &&
                        mainLoop.pages.first == inputHandler,
                    'Pages: ${mainLoop.pages.length}.');
              },
              onPushFunc: (mainLoop) {});
          await mainLoop.pushPage(handler);
          expect(handler.pushEvents.length, 1);
          await mainLoop.popPage();
          expect(handler.popEvents.length, 1);
          event = handler.popEvents.first;
          expect(event.mainLoop, mainLoop);
        },
      );
      test(
        'onReveal',
        () async {
          final coveringHandler = TestInputHandler(
            onPushFunc: (mainLoop) {},
            onPopFunc: (mainLoop) {},
          );
          final inputHandler = TestInputHandler(
              onPushFunc: (mainLoop) {},
              onPopFunc: (mainLoop) {},
              onRevealFunc: (mainLoop, covering) {
                assert(mainLoop.pages.length == 1,
                    'Pages: ${mainLoop.pages.length}.');
                assert(covering == coveringHandler,
                    '$covering != $coveringHandler.');
              });
          await mainLoop.pushPage(inputHandler);
          await mainLoop.pushPage(coveringHandler);
          await mainLoop.popPage();
          expect(coveringHandler.revealEvents, isEmpty);
          expect(inputHandler.revealEvents.length, 1);
          final event = inputHandler.revealEvents.first;
          expect(event.covering, coveringHandler);
          expect(event.mainLoop, mainLoop);
        },
      );
    },
  );
}
