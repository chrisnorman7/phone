/// Provides the [EditContactPage] class.
import '../../../constants.dart';
import '../../../main_loop.dart';
import '../../json/contacts.dart';
import '../../ui/input_handler.dart';
import '../../ui/label.dart';
import '../../ui/widget_page.dart';
import '../../ui/widgets/widget.dart';

/// A page used for adding a contact.
class EditContactPage extends WidgetPage {
  /// Create an instance.
  EditContactPage({required this.contact})
      : super(
            label: label('Edit Contact'),
            widgets: [],
            onCancel: (mainLoop) => mainLoop.popPage());

  /// The contact to edit.
  final Contact contact;

  /// Build the [widgets] list.
  @override
  Future<void> onPush(MainLoop mainLoop) async {
    widgets
      ..clear()
      ..addAll([
        Widget(
          label: () => 'First name: ${contact.firstName}',
        ),
        Widget(
          label: () => 'Surname: ${contact.surname}',
        ),
        Widget(
          label: () => 'Title: ${contact.title}',
        ),
        ...[
          for (final phoneNumber in contact.phoneNumbers)
            Widget(
              label: () => 'Phone number (${phoneNumber.numberType}): '
                  '${phoneNumber.number}',
            )
        ],
        ...[
          for (final emailAddress in contact.emailAddresses)
            Widget(
              label: () => 'Email Address (${emailAddress.addressType}): '
                  '${emailAddress.address}',
            )
        ],
        Widget(
          label: () {
            var preamble = 'Date of birth: ';
            final dateOfBirth = contact.dateOfBirth;
            if (dateOfBirth == null) {
              preamble += 'Not set';
            } else {
              preamble += dateTimeFormatter.format(dateOfBirth);
            }
            return preamble;
          },
        ),
        Widget(
          label: () => 'Website: ${contact.website}',
        ),
        Widget(
          label: () => 'Notes: ${contact.notes}',
        ),
        Widget(
            label: () => mainLoop.contactList.contacts.contains(contact)
                ? 'Save Contact'
                : 'Add Contact',
            onActivate: (mainLoop) async {
              if (mainLoop.contactList.contacts.contains(contact) == false) {
                mainLoop.contactList.contacts.add(contact);
              }
              mainLoop.contactList.save();
              await mainLoop.popPage();
            })
      ]);
    super.onPush(mainLoop);
  }

  /// Rebuild the [widgets] list.
  @override
  Future<void> onReveal(MainLoop mainLoop, InputHandler covering) async {
    onPush(mainLoop);
  }
}
