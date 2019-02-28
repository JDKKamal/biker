import 'package:biker/model/postpone/postpone_response.dart';

class PostPoneViewModel {
  List<PostPoneResponse> postPoneItems;

  PostPoneViewModel({this.postPoneItems});

  getPostPone() =>
      <PostPoneResponse>[
        PostPoneResponse(
            description: 'Pickup',
            refNo:123456.00,
            id: 1.00,
            lonerPhone: '1',
            assignTime: '20-02-2019 10:51PM',
            postponeTime: '24-02-2019 10:51PM',
            postponedReason: 'Outside',
            contactNo: '9586331823',
            endCustomer: 'Kamlesh',
            fullAddress: 'To. Ravani (Kuba) Ta. Visavadar Dis.Junagadh 362130',
            brand: 'MI',
            model: 'A2',
            codAmount: 1200.00
        )
      ];
}