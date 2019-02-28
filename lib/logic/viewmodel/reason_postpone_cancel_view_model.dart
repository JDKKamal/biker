import 'package:biker/model/reason/reason.dart';

class ReasonPostPoneCancelViewModel {
  List<ReasonResponse> reasonUndeliveredItems;

  ReasonPostPoneCancelViewModel({this.reasonUndeliveredItems});

  getReasonPostPoneCancel() =>
      <ReasonResponse>[
        ReasonResponse(
          isSelected: false,
          id: 1,
          reasonName: 'ADDRESS CHANGED',
        ),
        ReasonResponse(
          isSelected: false,
          id: 2,
          reasonName: 'BACKUP PENDING',
        ),
        ReasonResponse(
          isSelected: false,
          id: 3,
          reasonName: 'CALL LETTER',
        ),
        ReasonResponse(
          isSelected: false,
          id: 4,
          reasonName: 'DOOR LOCKED',
        ),
        ReasonResponse(
          isSelected: false,
          id: 5,
          reasonName: 'DUPLICATE INQUIRY',
        ),
        ReasonResponse(
          isSelected: false,
          id: 6,
          reasonName: 'HIGH ESTIMATE',
        ),
        ReasonResponse(
          isSelected: false,
          id: 7,
          reasonName: 'INCOMPLETE/INACCURATE INFORMATION',
        ),
        ReasonResponse(
          isSelected: false,
          id: 8,
          reasonName: 'NOT AGREE',
        ),
        ReasonResponse(
          isSelected: false,
          id: 9,
          reasonName: 'NOT AVIALABLE',
        ),
        ReasonResponse(
          isSelected: false,
          id: 10,
          reasonName: 'NOT RESPONDING',
        ), ReasonResponse(
          isSelected: false,
          id: 11,
          reasonName: 'OUT OF STATION',
        ),
        ReasonResponse(
          isSelected: false,
          id: 12,
          reasonName: 'PHONE MISPLACED',
        ),
        ReasonResponse(
          isSelected: false,
          id: 13,
          reasonName: 'PHONE NOT IN REPAIRABLE CONDITION',
        ), ReasonResponse(
          isSelected: false,
          id: 14,
          reasonName: 'WRONG NUMBER',
        )
      ];
}
