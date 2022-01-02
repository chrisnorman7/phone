/// Provides the [ContactListPage] class.
import '../../../main_loop.dart';
import '../../json/contacts.dart';
import '../../ui/input_handler.dart';
import '../../ui/label.dart';
import '../../ui/widget_page.dart';
import '../../ui/widgets/widget.dart';
import '../editor_page.dart';
import 'edit_contact_page.dart';

/// A page to view a [ContactList].
class ContactListPage extends WidgetPage {
  /// Create an instance.
  ContactListPage({required this.contactList})
      : super(
            label: label('Contacts'),
            widgets: [],
            loggerName: 'Contacts List Page');

  /// The contacts list to work with.
  final ContactList contactList;

  /// Build the [widgets] list.
  @override
  Future<void> onPush(MainLoop mainLoop) async {
    final contacts = List<Contact>.from(contactList.contacts)
      ..sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    widgets
      ..clear()
      ..add(
        Widget(
          label: label('Add Contact'),
          onActivate: (mainLoop) => mainLoop.pushPage(
            EditorPage(
              onDone: (text) async {
                if (text.isEmpty) {
                  await mainLoop.popPage();
                } else {
                  final contact = Contact(firstName: text);
                  await mainLoop.replacePage(EditContactPage(contact: contact));
                }
              },
              onCancel: (mainLoop) => mainLoop.popPage(),
              label: label('First name:'),
            ),
          ),
        ),
      );
    for (final contact in contacts) {
      widgets.add(Widget(
          label: () => contact.name,
          onActivate: (mainLoop) =>
              mainLoop.pushPage(EditContactPage(contact: contact))));
    }
    super.onPush(mainLoop);
  }

  /// This page has been revealed, build the [widgets] list again.
  @override
  Future<void> onReveal(MainLoop mainLoop, InputHandler covering) async {
    onPush(mainLoop);
  }
}
