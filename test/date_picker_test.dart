import 'package:phone/enumerations.dart';
import 'package:phone/src/pages/date_picker.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'DatePickerPage class',
    () {
      final mainLoop = DummyMainLoop();
      final initialDateTime = DateTime.now();
      DateTime? dateTime;
      final page = DatePicker(
        initialDateTime: initialDateTime,
        onDone: (date) async => dateTime = date,
      );
      test(
        'Initialisation',
        () {
          expect(dateTime, isNull);
          expect(page.initialDateTime, initialDateTime);
          expect(page.dateTime, initialDateTime);
          expect(page.maxDay, isNull);
          expect(page.maxMonth, isNull);
          expect(page.maxYear, isNull);
          expect(page.minDay, isNull);
          expect(page.minMonth, isNull);
          expect(page.minYear, isNull);
          expect(page.onCancel, isNull);
        },
      );
      test(
        '.onDone',
        () async {
          page.dateTime = DateTime(1992);
          expect(page.dateTime, isNot(initialDateTime));
          await page.handleKeyEvent(KeyEvent.enter, mainLoop);
          expect(dateTime, page.dateTime);
        },
      );
      test(
        '.onCancel',
        () async {
          var cancel = 0;
          final cancelPage = DatePicker(
            initialDateTime: initialDateTime,
            onDone: page.onDone,
            onCancel: (mainLoop) async => cancel++,
          );
          expect(cancel, isZero);
          await cancelPage.handleKeyEvent(KeyEvent.cancel, mainLoop);
          expect(cancel, 1);
          await cancelPage.handleKeyEvent(KeyEvent.cancel, mainLoop);
          expect(cancel, 2);
        },
      );
      test(
        'Reset defaults',
        () async {
          page.dateTime = DateTime(1, 2, 3, 4);
          expect(page.dateTime, isNot(initialDateTime));
          await page.handleKeyEvent(KeyEvent.key0, mainLoop);
          expect(page.dateTime, initialDateTime);
        },
      );
      test(
        '.years',
        () async {
          page.dateTime = initialDateTime;
          final year = page.dateTime.year;
          await page.handleKeyEvent(KeyEvent.key1, mainLoop);
          expectDateTime(page.dateTime, year: year + 1);
          await page.handleKeyEvent(KeyEvent.key7, mainLoop);
          expectDateTime(page.dateTime, year: year);
          await page.handleKeyEvent(KeyEvent.key7, mainLoop);
          expectDateTime(page.dateTime, year: year - 1);
          await page.handleKeyEvent(KeyEvent.key4, mainLoop);
          expectDateTime(page.dateTime, year: year);
          await page.handleKeyEvent(KeyEvent.key4, mainLoop);
          expectDateTime(page.dateTime, year: year);
        },
      );
      test(
        '.months',
        () async {
          page.dateTime = DateTime(initialDateTime.year, 5);
          final month = page.dateTime.month;
          await page.handleKeyEvent(KeyEvent.key2, mainLoop);
          expectDateTime(page.dateTime, month: month + 1);
          await page.handleKeyEvent(KeyEvent.key8, mainLoop);
          expectDateTime(page.dateTime, month: month);
          await page.handleKeyEvent(KeyEvent.key8, mainLoop);
          expectDateTime(page.dateTime, month: month - 1);
          await page.handleKeyEvent(KeyEvent.key5, mainLoop);
          expectDateTime(page.dateTime, month: initialDateTime.month);
          await page.handleKeyEvent(KeyEvent.key5, mainLoop);
          expectDateTime(page.dateTime, month: initialDateTime.month);
        },
      );
      test(
        '.days',
        () async {
          page.dateTime = initialDateTime;
          final day = page.dateTime.day;
          await page.handleKeyEvent(KeyEvent.key3, mainLoop);
          expectDateTime(page.dateTime, day: day + 1);
          await page.handleKeyEvent(KeyEvent.key9, mainLoop);
          expectDateTime(page.dateTime, day: day);
          await page.handleKeyEvent(KeyEvent.key9, mainLoop);
          expectDateTime(page.dateTime, day: day - 1);
          await page.handleKeyEvent(KeyEvent.key6, mainLoop);
          expectDateTime(page.dateTime, day: day);
          await page.handleKeyEvent(KeyEvent.key6, mainLoop);
          expectDateTime(page.dateTime, day: day);
        },
      );
      test(
        'Min and max years',
        () async {
          const year = 1990;
          const month = 5;
          const day = 15;
          final boundedPage = DatePicker(
            initialDateTime: DateTime(year, month, day),
            onDone: page.onDone,
            minDay: day - 3,
            maxDay: day + 3,
            minMonth: month - 3,
            maxMonth: month + 3,
            maxYear: year + 3,
            minYear: year - 3,
          );
          await boundedPage.handleKeyEvent(KeyEvent.key1, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year + 1, month: month, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key1, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year + 2, month: month, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key1, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year + 3, month: month, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key1, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year + 3, month: month, day: day);
          await boundedPage.resetDateTime(mainLoop: mainLoop, year: year);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key7, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year - 1, month: month, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key7, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year - 2, month: month, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key7, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year - 3, month: month, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key7, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year - 3, month: month, day: day);
        },
      );
      test(
        'Min and max months',
        () async {
          const year = 1990;
          const month = 5;
          const day = 15;
          final boundedPage = DatePicker(
            initialDateTime: DateTime(year, month, day),
            onDone: page.onDone,
            minDay: day - 3,
            maxDay: day + 3,
            minMonth: month - 3,
            maxMonth: month + 3,
            maxYear: year + 3,
            minYear: year - 3,
          );
          await boundedPage.handleKeyEvent(KeyEvent.key2, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month + 1, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key2, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month + 2, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key2, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month + 3, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key2, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month + 3, day: day);
          await boundedPage.resetDateTime(mainLoop: mainLoop, month: month);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key8, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month - 1, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key8, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month - 2, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key8, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month - 3, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key8, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month - 3, day: day);
        },
      );
      test(
        'Min and max days',
        () async {
          const year = 1990;
          const month = 5;
          const day = 15;
          final boundedPage = DatePicker(
            initialDateTime: DateTime(year, month, day),
            onDone: page.onDone,
            minDay: day - 3,
            maxDay: day + 3,
            minMonth: month - 3,
            maxMonth: month + 3,
            maxYear: year + 3,
            minYear: year - 3,
          );
          await boundedPage.handleKeyEvent(KeyEvent.key3, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month, day: day + 1);
          await boundedPage.handleKeyEvent(KeyEvent.key3, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month, day: day + 2);
          await boundedPage.handleKeyEvent(KeyEvent.key3, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month, day: day + 3);
          await boundedPage.handleKeyEvent(KeyEvent.key3, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month, day: day + 3);
          await boundedPage.resetDateTime(mainLoop: mainLoop, day: day);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month, day: day);
          await boundedPage.handleKeyEvent(KeyEvent.key9, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month, day: day - 1);
          await boundedPage.handleKeyEvent(KeyEvent.key9, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month, day: day - 2);
          await boundedPage.handleKeyEvent(KeyEvent.key9, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month, day: day - 3);
          await boundedPage.handleKeyEvent(KeyEvent.key9, mainLoop);
          expectDateTime(boundedPage.dateTime,
              year: year, month: month, day: day - 3);
        },
      );
    },
  );
}
