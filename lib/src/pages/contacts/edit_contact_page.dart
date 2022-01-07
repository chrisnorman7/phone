/// Provides the [EditContactPage] class.
import '../../../constants.dart';
import '../../../enumerations.dart';
import '../../../main_loop.dart';
import '../../json/contacts.dart';
import '../../ui/input_handler.dart';
import '../../ui/label.dart';
import '../../ui/widget_page.dart';
import '../../ui/widgets/widget.dart';
import '../date_picker.dart';
import '../editor_page.dart';
import '../yes_no_page.dart';
import 'contact_details_page.dart';

/// Edit a contact parameter.
Future<void> Function(MainLoop mainLoop) _editContactParameter({
  required String label,
  required String initialText,
  required void Function(String text) setValue,
}) =>
    (mainLoop) => mainLoop.pushPage(EditorPage(
        onDone: (text) async {
          if (text.isNotEmpty && text != initialText) {
            setValue(text);
            mainLoop.contactList.save();
          }
          await mainLoop.popPage();
        },
        cursorPosition: initialText.length,
        initialText: initialText,
        label: () => '$label: ',
        onCancel: (mainLoop) => mainLoop.popPage(),
        mode:
            initialText.isEmpty ? TypingMode.upperCase : TypingMode.lowerCase));

/// A page used for editing a [contact].
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
          onActivate: _editContactParameter(
            initialText: contact.firstName,
            label: 'First name',
            setValue: (text) => contact.firstName = text,
          ),
        ),
        Widget(
          label: () => 'Surname: ${contact.surname}',
          onActivate: _editContactParameter(
            initialText: contact.surname,
            label: 'Surname',
            setValue: (text) => contact.surname = text,
          ),
        ),
        Widget(
          label: () => 'Title: ${contact.title}',
          onActivate: _editContactParameter(
            initialText: contact.title,
            label: 'Title',
            setValue: (text) => contact.title = text,
          ),
        ),
        Widget(
          label: label('Add Phone Number'),
          onActivate: (mainLoop) => addContactDetail(
            mainLoop: mainLoop,
            onDone: (detailType, detailValue) async {
              contact.phoneNumbers.add(
                PhoneNumber(
                  number: detailValue,
                  numberType: detailType,
                ),
              );
              mainLoop.contactList.save();
              await mainLoop.popPage();
            },
            editorLabel: 'Phone Number',
            detailTypeLabel: 'Phone Number Label',
            typingMode: TypingMode.numbers,
          ),
        ),
        ...[
          for (final phoneNumber in contact.phoneNumbers)
            Widget(
              label: () => 'Phone number (${phoneNumber.numberType}): '
                  '${phoneNumber.number}',
              onActivate: (mainLoop) => mainLoop.pushPage(
                EditDetailPage(
                  detailType: phoneNumber.numberType,
                  detailValue: phoneNumber.number,
                  onDone: (detailType, detailValue) {
                    phoneNumber
                      ..number = detailValue
                      ..numberType = detailType;
                    mainLoop.contactList.save();
                    return mainLoop.popPage();
                  },
                  editorLabel: 'Phone number',
                  detailTypeLabel: 'Phone Number Type',
                  typingMode: TypingMode.numbers,
                ),
              ),
            )
        ],
        Widget(
          label: label('Add Email Address'),
          onActivate: (mainLoop) => addContactDetail(
            mainLoop: mainLoop,
            onDone: (detailType, detailValue) {
              contact.emailAddresses.add(
                EmailAddress(address: detailValue, addressType: detailType),
              );
              mainLoop.contactList.save();
              return mainLoop.popPage();
            },
            editorLabel: 'Email address',
            detailTypeLabel: 'Email Address Type',
          ),
        ),
        ...[
          for (final emailAddress in contact.emailAddresses)
            Widget(
              label: () => 'Email Address (${emailAddress.addressType}): '
                  '${emailAddress.address}',
              onActivate: (mainLoop) => mainLoop.pushPage(
                EditDetailPage(
                  detailType: emailAddress.addressType,
                  detailValue: emailAddress.address,
                  onDone: (detailType, detailValue) {
                    emailAddress
                      ..address = detailValue
                      ..addressType = detailType;
                    mainLoop.contactList.save();
                    return mainLoop.popPage();
                  },
                  editorLabel: 'Email address',
                  detailTypeLabel: 'Email Type',
                ),
              ),
            )
        ],
        Widget(
          label: () {
            var preamble = 'Date of birth: ';
            final dateOfBirth = contact.dateOfBirth;
            if (dateOfBirth == null) {
              preamble += 'Not set';
            } else {
              preamble += dateFormatter.format(dateOfBirth);
            }
            return preamble;
          },
          onActivate: (mainLoop) => mainLoop.pushPage(
            DatePicker(
              initialDateTime: contact.dateOfBirth ?? DateTime.now(),
              onDone: (dateTime) async {
                contact.dateOfBirth = dateTime;
                mainLoop.contactList.save();
                await mainLoop.popPage();
              },
              onCancel: (mainLoop) => mainLoop.popPage(),
            ),
          ),
        ),
        Widget(
          label: () => 'Website: ${contact.website}',
          onActivate: _editContactParameter(
            initialText: contact.website,
            label: 'Website',
            setValue: (text) => contact.website = text,
          ),
        ),
        Widget(
          label: () => 'Notes: ${contact.notes}',
          onActivate: _editContactParameter(
            initialText: contact.notes,
            label: 'Notes',
            setValue: (text) => contact.notes = text,
          ),
        ),
        Widget(
          label: () => mainLoop.contactList.contacts.contains(contact)
              ? 'Delete Contact'
              : 'Save Contact',
          onActivate: (mainLoop) {
            final contacts = mainLoop.contactList;
            if (contacts.contacts.contains(contact)) {
              return mainLoop.pushPage(
                YesNoPage(
                    yesCallback: (mainLoop) {
                      contacts
                        ..contacts.remove(contact)
                        ..save();
                      return mainLoop.popPage();
                    },
                    noCallback: (mainLoop) => mainLoop.popPage(),
                    question: () =>
                        'Are you sure you want to delete ${contact.fullName}?'),
              );
            } else {
              contacts
                ..contacts.add(contact)
                ..save();
              return mainLoop.popPage();
            }
          },
        )
      ]);
    super.onPush(mainLoop);
  }

  /// Rebuild the [widgets] list.
  @override
  Future<void> onReveal(MainLoop mainLoop, InputHandler covering) async {
    onPush(mainLoop);
  }
}
