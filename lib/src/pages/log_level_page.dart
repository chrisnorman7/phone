/// Provides the [LogLevelPage] class.
import 'package:logging/logging.dart';

import '../../main_loop.dart';
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';

/// A page for selecting a log level.
class LogLevelPage extends WidgetPage {
  /// Create an instance.
  LogLevelPage()
      : super(
            label: label('Log Level'),
            widgets: [
              for (final level in Level.LEVELS)
                Widget(
                    label: label(level.name),
                    onActivate: (mainLoop) async {
                      Logger.root.level = level;
                      logLevelFile.writeAsStringSync(level.name);
                      await mainLoop.popPage();
                    })
            ],
            onCancel: (mainLoop) => mainLoop.popPage());
}
