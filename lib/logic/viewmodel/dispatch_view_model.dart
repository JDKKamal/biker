import 'package:biker/model/dispatch/dispatch_response.dart';

class DispatchViewModel {
  List<DispatchResponse> dispatchItems;

  DispatchViewModel({this.dispatchItems});

  getDispatch() => <DispatchResponse>[
    DispatchResponse(
            jobId: '123456',
            lonerPhone: 1,
            name: 'Lakhani Kamlesh J.',
            mobile: '9586331823',
            address: 'To. Ravani (Kuba) Ta. Visavadar Dis.Junagadh 362130',
            brand: 'MI',
            model: 'A2',
            codAmount: 1200.00,
            dispatchDateTime: '25-02-2019 10:51PM'),

    DispatchResponse(
        jobId: '1234567',
        lonerPhone: 0,
        name: 'Lakhani Nayan J.',
        mobile: '7990971929',
        address: 'To. Ravani (Kuba) Ta. Visavadar Dis.Junagadh 362130',
        brand: 'MI',
        model: 'A2',
        codAmount: 1300.00,
        dispatchDateTime: '25-02-2019 10:51PM')
      ];
}