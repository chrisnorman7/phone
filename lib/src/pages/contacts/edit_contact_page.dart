/// Provides the [EditContactPage] class.
import '../../../constants.dart';
import '../../json/contacts.dart';
import '../../ui/label.dart';
import '../../ui/widget_page.dart';
import '../../ui/widgets/widget.dart';

/// A page used for adding a contact.
class EditContactPage extends WidgetPage {
  /// Create an instance.
  EditContactPage({required this.contact})
      : super(label: label('Edit Contact'), widgets: [
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
          )
        ]);

  /// The contact to edit.
  final Contact contact;
}
