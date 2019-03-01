import 'package:biker/model/contact/contact_response.dart';

class ContactViewModel {
  List<ContactResponse> contactItems;
  ContactViewModel({this.contactItems});

  getContacts() =>
      <ContactResponse>[
        ContactResponse(
          name: 'JDK GROUP',
          address: 'To.Ravani (Kuba) Ta.Visavadar Dis.Junagadh \n Ravani (Kuba) - 362130. \nGujarat, India.',
          mobile: '9586331823',
          websiteName: '',
        ),
      ];
}
