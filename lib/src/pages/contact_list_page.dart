/// Provides the [ContactListPage] class.
import '../json/contacts.dart';
import '../ui/label.dart';
import '../ui/widget_page.dart';
import '../ui/widgets/widget.dart';

/// A page to view a [ContactList].
class ContactListPage extends WidgetPage {
  /// Create an instance.
  ContactListPage(ContactList contactList)
      : super(
            label: label('Contacts'),
            widgets: [],
            loggerName: 'Contacts List Page') {
    final contacts = List<Contact>.from(contactList.contacts)
      ..sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    for (final contact in contacts) {
      widgets.add(Widget(label: label(contact.name)));
    }
  }
}
