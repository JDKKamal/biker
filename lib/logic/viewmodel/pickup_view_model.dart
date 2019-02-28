import 'package:biker/model/pickup/pickup_response.dart';

class PickUpViewModel {
  List<PickUpResponse> pickUpItems;

  PickUpViewModel({this.pickUpItems});

  getPickUp() => <PickUpResponse>[
        PickUpResponse(
            inquiryNo: 123456,
            name: 'Lakhani Kamlesh J.',
            brand: 'MI',
            mobile: '9586331823',
            address: 'To. Ravani (Kuba) Ta. Visavadar Dis.Junagadh 362130',
            model: 'A2',
            pickUpDateTime: '20-02-2019 10:51PM'),

        PickUpResponse(
            inquiryNo: 1234567,
            name: 'Lakhani Nayan J.',
            brand: 'MI',
            mobile: '7990971929',
            address: 'To. Ravani (Kuba) Ta. Visavadar Dis.Junagadh 362130',
            model: 'A2',
            pickUpDateTime: '20-02-2019 10:51PM')
      ];
}
