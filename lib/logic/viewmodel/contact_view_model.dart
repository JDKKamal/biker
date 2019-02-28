import 'package:biker/model/contact/contact_response.dart';

class ContactViewModel {
  List<ContactResponse> contactItems;
  ContactViewModel({this.contactItems});

  getContacts() =>
      <ContactResponse>[
        ContactResponse(
          name: 'Qarmatek Services Pvt Ltd',
          address: '2nd Floor, Shashwat Business Park, \nOpp. Soma Textiles, Rakhial, \nAhmedabad- 380023. \nGujarat, India.',
          mobile: '079 2970 0134',
          websiteName: '',
        ),
        ContactResponse(
          name: 'Repair Center - Gujarat',
          address: 'No. 177, Behind Swaraj Mazda Workshop, Narol- Aslali Road, \nAhmedabad- 382440, \nGujarat, India.',
          mobile: '',
          websiteName: '',
        ),
        ContactResponse(
          name: 'Repair Center - Maharashtra',
          address: 'No.82, BLD-B-2, Near Kalaudyog INDL EST, Dasmesh Marg, \nOpp Hyundai Serivce Center, Bhandup (W), \nMumbai – 400 078. \nMaharashtra, INDIA.',
          mobile: '',
          websiteName: '',
        ),
        ContactResponse(
          name: 'Repair Center - Karnataka',
          address: '3rd Floor, Harini Towers, 3rd Cross, 3rd Main, Off Outer Ring Road, 2nd Stage, Peenya Industrial Area, \nBanglore – 560 022. \nKarnataka, INDIA.',
          mobile: '',
          websiteName: '',
        ),
        ContactResponse(
          name: 'Repair Center - West Bengal',
          address:  'Next to Reliance Market, DIESL Warehouse, Budge Budge Trunk (BBT) Road, Benepukur, \nKolkata – 700 143. \nWest Bengal, INDIA.',
          mobile: '',
          websiteName: '',
        )
      ];
}
