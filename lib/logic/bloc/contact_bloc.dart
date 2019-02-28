import 'dart:async';

import 'package:biker/logic/viewmodel/contact_view_model.dart';
import 'package:biker/model/contact/contact_response.dart';

class ContactBloc {
  final _contactVM = ContactViewModel();
  final contactController = StreamController<List<ContactResponse>>();

  Stream<List<ContactResponse>> get contactItems => contactController.stream;

  ContactBloc() {
    contactController.add(_contactVM.getContacts());
  }
}
