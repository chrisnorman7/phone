/// Provides classes for viewing log files.
import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:path/path.dart' as path;

import '../../constants.dart';
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';

/// A page to view a specific log file.
class LogViewerPage extends WidgetPage {
  /// Create an instance.
  LogViewerPage()
      : super(
            label: label('Log Files'),
            widgets: [
              for (final entity in logDirectory.listSync())
                if (entity is File)
                  Widget(
                      label: () => '${path.basename(entity.path)}: '
                          '${filesize(entity.statSync().size)}',
                      onActivate: (mainLoop) async {
                        final page = WidgetPage(
                            label: label('Log Entries'),
                            widgets: [
                              for (final line in entity.readAsLinesSync())
                                Widget(label: label(line))
                            ]);
                        await mainLoop.pushPage(page);
                      })
            ],
            onCancel: (mainLoop) => mainLoop.popPage());
}
