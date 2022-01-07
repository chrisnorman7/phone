import '../../../enumerations.dart';
import '../../../main_loop.dart';
import '../../ui/label.dart';
import '../../ui/widget_page.dart';
import '../../ui/widgets/widget.dart';
import '../editor_page.dart';
import 'detail_type_page.dart';

/// The type for the `onDone` function.
typedef ContactDetailCallback = Future<void> Function(
    String detailType, String detailValue);

/// Add a contact detail.
Future<void> addContactDetail({
  required MainLoop mainLoop,
  required ContactDetailCallback onDone,
  required String editorLabel,
  String detailTypeLabel = 'Detail Type',
  TypingMode typingMode = TypingMode.lowerCase,
}) async =>
    mainLoop.pushPage(
      DetailTypePage(
        onDone: (mainLoop, detailType) => mainLoop.replacePage(
          EditorPage(
            onDone: (text) async {
              if (text.isEmpty) {
                return mainLoop.speak('You must enter something.');
              } else {
                onDone(detailType, text);
              }
            },
            label: label(editorLabel),
            mode: typingMode,
          ),
        ),
        menuLabel: detailTypeLabel,
      ),
    );

/// A page for editing phone numbers.
class EditDetailPage extends WidgetPage {
  /// Create an instance.
  EditDetailPage({
    required this.detailType,
    required this.detailValue,
    required this.onDone,
    required this.editorLabel,
    this.detailTypeLabel = 'Detail Type',
    this.typingMode = TypingMode.lowerCase,
  }) : super(
          label: label('Contact Detail Editor'),
          widgets: [],
          onCancel: (mainLoop) => mainLoop.popPage(),
        );

  /// The type of the detail.
  String detailType;

  /// The value of the detail.
  String detailValue;

  /// What to do with the finalised details.
  final ContactDetailCallback onDone;

  /// The label to use when editing [detailValue].
  final String editorLabel;

  /// The label to use when changing the [detailType].
  final String detailTypeLabel;

  /// The typing mode to use when editing [detailValue].
  final TypingMode typingMode;

  /// Populate the list of phone numbers.
  @override
  Future<void> onPush(MainLoop mainLoop) async {
    widgets
      ..clear()
      ..addAll(
        [
          Widget(
            label: () => detailValue,
            onActivate: (mainLoop) => mainLoop.pushPage(
              EditorPage(
                onDone: (text) async {
                  if (text.isNotEmpty) {
                    detailValue = text;
                    return mainLoop.popPage();
                  } else {
                    return mainLoop.speak('You must provide a value.');
                  }
                },
                initialText: detailValue,
                label: label(editorLabel),
                mode: typingMode,
                onCancel: (mainLoop) => mainLoop.popPage(),
              ),
            ),
          ),
          Widget(
            label: () => 'Type: $detailType',
            onActivate: (mainLoop) => mainLoop.pushPage(
              DetailTypePage(
                onDone: (mainLoop, value) {
                  detailType = value;
                  return mainLoop.popPage();
                },
                currentValue: detailType,
                menuLabel: detailTypeLabel,
              ),
            ),
          ),
          Widget(
            label: label('Save'),
            onActivate: (mainLoop) => onDone(detailType, detailValue),
          )
        ],
      );
    super.onPush(mainLoop);
  }
}
