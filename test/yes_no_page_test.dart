import 'package:phone/enumerations.dart';
import 'package:phone/main_loop.dart';
import 'package:phone/src/pages/yes_no_page.dart';
import 'package:test/test.dart';

import 'common.dart';

/// An empty callback.
Future<void> emptyCallback(MainLoop mainLoop) async {}
void main() {
  group(
    'YesNoPage class',
    () {
      final mainLoop = DummyMainLoop();
      var yes = 0;
      var no = 0;
      final page = YesNoPage(
        yesCallback: (mainLoop) async => yes++,
        noCallback: (mainLoop) async => no++,
      );
      test(
        'Initialisation',
        () {
          expect(page.noLabel, defaultNoLabel);
          expect(page.yesLabel, defaultYesLabel);
          expect(page.onCancel, isNull);
          expect(yes, isZero);
          expect(no, isZero);
          expect(page.currentWidget, isNull);
          expect(page.widgets.length, 2);
        },
      );
      test(
        'Yes',
        () async {
          await page.handleKeyEvent(KeyEvent.right, mainLoop);
          final widget = page.currentWidget;
          expect(widget, page.widgets.first);
          widget!;
          expect(widget.label, defaultYesLabel);
          await page.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(yes, 1);
          await page.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(yes, 2);
        },
      );
      test(
        'No',
        () async {
          await page.handleKeyEvent(KeyEvent.right, mainLoop);
          final widget = page.currentWidget;
          expect(widget, page.widgets.last);
          widget!;
          expect(widget.label, defaultNoLabel);
          await page.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(no, 1);
          expect(yes, 2);
          await page.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(no, 2);
          expect(yes, 2);
          await page.handleKeyEvent(KeyEvent.right, mainLoop);
          expect(page.currentWidget, widget);
          await page.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(no, 3);
          expect(yes, 2);
        },
      );
    },
  );
}
