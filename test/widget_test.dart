import 'package:phone/enumerations.dart';
import 'package:phone/ui.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'Widget class',
    () {
      test(
        'Initialisation',
        () {
          final widget = Widget(label: label('Testing'));
          expect(widget.label(), 'Testing');
          expect(widget.handledKeys, isEmpty);
          expect(widget.onActivate, isNull);
        },
      );
    },
  );
  group(
    'WidgetPage class',
    () {
      final widget1 = Widget(label: label('Widget 1'));
      final widget2 = Widget(label: label('Widget 2'));
      final page =
          WidgetPage(label: label('Page'), widgets: [widget1, widget2]);
      final mainLoop = DummyMainLoop();
      final speech = mainLoop.speechEngine as DummySpeechEngine;
      setUp(speech.utterances.clear);
      test(
        'Initialisation',
        () {
          expect(page.currentWidget, isNull);
          expect(page.infoModeKeys.length, 2);
          expect(page.label(), 'Page');
          expect(page.logger.name, 'Untitled Page');
          expect(page.navigationMode, NavigationMode.standard);
          expect(page.onCancel, isNull);
          expect(page.widgets, [widget1, widget2]);
        },
      );
      test(
        'pushPage',
        () async {
          expect(speech.utterances, isEmpty);
          await mainLoop.pushPage(page);
          expect(speech.utterances.length, 1);
          final utterance = speech.utterances.first;
          expect(utterance.interrupt, isTrue);
          expect(utterance.text, '${page.label()} with 2 items');
        },
      );
      test(
        '.moveRight',
        () async {
          await page.handleKeyEvent(KeyEvent.right, mainLoop);
          expect(page.currentWidget, widget1);
          expect(speech.utterances.length, 1);
          var utterance = speech.utterances.first;
          expect(utterance.interrupt, isTrue);
          expect(utterance.text, widget1.label());
          await page.handleKeyEvent(KeyEvent.right, mainLoop);
          expect(page.currentWidget, widget2);
          expect(speech.utterances.length, 2);
          utterance = speech.utterances.last;
          expect(utterance.interrupt, isTrue);
          expect(utterance.text, widget2.label());
          await page.handleKeyEvent(KeyEvent.right, mainLoop);
          expect(page.currentWidget, widget2);
          expect(speech.utterances.length, 3);
          utterance = speech.utterances.last;
          expect(utterance.interrupt, isTrue);
          expect(utterance.text, widget2.label());
        },
      );
      test(
        '.moveLeft',
        () async {
          await page.handleKeyEvent(KeyEvent.left, mainLoop);
          expect(page.currentWidget, widget1);
          expect(speech.utterances.length, 1);
          var utterance = speech.utterances.first;
          expect(utterance.interrupt, isTrue);
          expect(utterance.text, widget1.label());
          await page.handleKeyEvent(KeyEvent.left, mainLoop);
          expect(page.currentWidget, isNull);
          expect(speech.utterances.length, 2);
          utterance = speech.utterances.last;
          expect(utterance.interrupt, isTrue);
          expect(utterance.text, '${page.label()} with 2 items');
        },
      );
    },
  );
}
