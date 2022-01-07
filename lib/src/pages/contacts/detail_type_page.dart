/// Provides the [DetailTypePage] class.
import '../../../constants.dart';
import '../../../main_loop.dart';
import '../../ui/label.dart';
import '../../ui/widget_page.dart';
import '../../ui/widgets/widget.dart';

/// A page which allows the selection of a contact detail type.
class DetailTypePage extends WidgetPage {
  /// Create an instance.
  DetailTypePage({
    required this.onDone,
    String menuLabel = 'Detail Type',
    String? currentValue,
  }) : super(
          label: label(menuLabel),
          widgets: [
            for (final detailType in defaultContactDetailLabels)
              Widget(
                  label: () =>
                      detailType +
                      (currentValue == detailType
                          ? ' (currently selected)'
                          : ''),
                  onActivate: (mainLoop) => onDone(
                        mainLoop,
                        detailType,
                      ))
          ],
          onCancel: (mainLoop) => mainLoop.popPage(),
        );

  /// What to do with the resulting type.
  final Future<void> Function(MainLoop mainLoop, String detailType) onDone;
}
