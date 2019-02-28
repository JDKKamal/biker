import 'package:biker/model/reason/reason.dart';

class ReasonUndeliveredViewModel {
  List<ReasonResponse> reasonUndeliveredItems;

  ReasonUndeliveredViewModel({this.reasonUndeliveredItems});

  getReasonUndelivered() =>
      <ReasonResponse>[
        ReasonResponse(
          isSelected: false,
          id: 1,
          reasonName: 'DATA MISSING',
        ),
        ReasonResponse(
          isSelected: false,
          id: 2,
          reasonName: 'DON NOT HAVE JOBSHEET',
        ),
        ReasonResponse(
          isSelected: false,
          id: 3,
          reasonName: 'DUPLICATE PARTS',
        ),
        ReasonResponse(
          isSelected: false,
          id: 4,
          reasonName: 'FITTING ISSUE',
        ),
        ReasonResponse(
          isSelected: false,
          id: 5,
          reasonName: 'OTHER PROBLEM FOUND',
        ),
        ReasonResponse(
          isSelected: false,
          id: 6,
          reasonName: 'PAYMENT ISSUE',
        ),
        ReasonResponse(
          isSelected: false,
          id: 7,
          reasonName: 'PROBLEM NOT SOLVED',
        ),

      ];
}
