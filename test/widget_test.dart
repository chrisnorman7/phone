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
          speech.expectUtterance(
              length: 1, interrupt: true, text: '${page.label()} with 2 items');
        },
      );
      test(
        '.moveRight',
        () async {
          await page.handleKeyEvent(KeyEvent.right, mainLoop);
          expect(page.currentWidget, widget1);
          speech.expectUtterance(
              length: 1, interrupt: true, text: widget1.label());
          await page.handleKeyEvent(KeyEvent.right, mainLoop);
          expect(page.currentWidget, widget2);
          speech.expectUtterance(
              length: 2, interrupt: true, text: widget2.label());
          await page.handleKeyEvent(KeyEvent.right, mainLoop);
          expect(page.currentWidget, widget2);
          speech.expectUtterance(
              length: 3, interrupt: true, text: widget2.label());
        },
      );
      test(
        '.moveLeft',
        () async {
          await page.handleKeyEvent(KeyEvent.left, mainLoop);
          expect(page.currentWidget, widget1);
          speech.expectUtterance(
              length: 1, interrupt: true, text: widget1.label());
          await page.handleKeyEvent(KeyEvent.left, mainLoop);
          expect(page.currentWidget, isNull);
          speech.expectUtterance(
              length: 2, interrupt: true, text: '${page.label()} with 2 items');
        },
      );
      test(
        'Widget.onActivate',
        () async {
          var i = 0;
          final widget3 = Widget(
              label: label('Widget 3'),
              onActivate: (mainLoop) async {
                i++;
              });
          page.widgets.add(widget3);
          while (page.currentWidget != widget2) {
            await page.moveRight(mainLoop);
          }
          expect(i, isZero);
          await page.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(i, isZero);
          await page.moveRight(mainLoop);
          await page.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(i, 1);
          await page.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(i, 2);
        },
      );
      test(
        '.onCancel',
        () async {
          var i = 0;
          await page.handleKeyEvent(KeyEvent.cancel, mainLoop);
          expect(i, isZero);
          final p = WidgetPage(
            label: page.label,
            widgets: page.widgets,
            onCancel: (mainLoop) async {
              i++;
            },
          );
          await p.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(i, isZero);
          await p.handleKeyEvent(KeyEvent.cancel, mainLoop);
          expect(i, 1);
          await p.handleKeyEvent(KeyEvent.cancel, mainLoop);
          expect(i, 2);
        },
      );
      test(
        'Home key',
        () async {
          await page.moveRight(mainLoop);
          expect(page.currentWidget, isNot(widget1));
          speech.utterances.clear();
          await page.handleKeyEvent(KeyEvent.key2, mainLoop);
          expect(page.currentWidget, widget1);
          speech.expectUtterance(
              length: 1, interrupt: true, text: widget1.label());
        },
      );
      test(
        'End key',
        () async {
          while (page.widgets.length > 2) {
            page.widgets.removeLast();
          }
          await page.moveLeft(mainLoop);
          expect(page.currentWidget, isNot(widget2));
          speech.utterances.clear();
          await page.handleKeyEvent(KeyEvent.key8, mainLoop);
          expect(page.currentWidget, widget2);
          speech.expectUtterance(
              length: 1, interrupt: true, text: widget2.label());
        },
      );
      test(
        'Move by letter',
        () async {
          final apples = Widget(label: label('Apples'), debugName: 'Apples');
          final bananas = Widget(label: label('Bananas'), debugName: 'Bananas');
          final babyOranges =
              Widget(label: label('Baby Oranges'), debugName: 'Baby Oranges');
          final mellons = Widget(label: label('Mellons'), debugName: 'Mellons');
          final papayas = Widget(label: label('Papayas'), debugName: 'Papayas');
          final page = WidgetPage(
            label: label('Fruit'),
            widgets: [
              apples,
              bananas,
              babyOranges,
              mellons,
              papayas,
            ],
          );
          const upEvent = KeyEvent.key4;
          const downEvent = KeyEvent.key6;
          await page.handleKeyEvent(downEvent, mainLoop);
          expect(page.currentWidget, isNull);
          expect(speech.utterances, isEmpty);
          await page.handleKeyEvent(upEvent, mainLoop);
          expect(page.currentWidget, isNull);
          expect(speech.utterances, isEmpty);
          await page.moveRight(mainLoop);
          speech.utterances.clear();
          await page.handleKeyEvent(downEvent, mainLoop);
          expect(page.currentWidget, bananas);
          speech.expectUtterance(
              length: 1, interrupt: true, text: bananas.label());
          await page.handleKeyEvent(downEvent, mainLoop);
          expect(page.currentWidget, mellons);
          speech.expectUtterance(
              length: 2, interrupt: true, text: mellons.label());
          await page.handleKeyEvent(upEvent, mainLoop);
          expect(page.currentWidget, babyOranges);
          speech.expectUtterance(
              length: 3, interrupt: true, text: babyOranges.label());
          await page.handleKeyEvent(downEvent, mainLoop);
          expect(page.currentWidget, mellons);
          speech.expectUtterance(
              length: 4, interrupt: true, text: mellons.label());
          await page.handleKeyEvent(downEvent, mainLoop);
          expect(page.currentWidget, papayas);
          speech.expectUtterance(
              length: 5, interrupt: true, text: papayas.label());
        },
      );
    },
  );
}
