import 'package:phone/src/json/contacts.dart';
import 'package:test/test.dart';

void main() {
  final contactList = ContactList();
  group(
    'ContactList class',
    () {
      test(
        'Initialisation',
        () {
          expect(contactList.contacts, isEmpty);
        },
      );
    },
  );
  group(
    'Contact class',
    () {
      final contact = Contact(
        firstName: 'Chris',
        surname: 'Norman',
        emailAddresses: [
          EmailAddress(
              address: 'chris.norman2@googlemail.com', addressType: 'Personal')
        ],
        website: 'https://github.com/chrisnorman7',
      );
      test(
        'Initialisation',
        () {
          expect(contact.dateOfBirth, isNull);
          expect(contact.emailAddresses.length, 1);
          expect(
              contact.emailAddresses.first,
              predicate(
                (value) =>
                    value is EmailAddress &&
                    value.address == 'chris.norman2@googlemail.com' &&
                    value.addressType == 'Personal',
              ));
          expect(contact.groups, isEmpty);
        },
      );
      test(
        '.name',
        () {
          expect(contact.name, 'Chris Norman');
          contact.title = 'Mr';
          expect(contact.fullName, 'Mr. Chris Norman');
        },
      );
    },
  );
}
