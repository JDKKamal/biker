import 'dart:async';
import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/ui/widgets/common_dialogs.dart';
import 'package:biker/utils/uidata.dart';
import 'package:rxdart/rxdart.dart';

class ReasonPostPoneCancelBloc {
  bool flag = true;
  final reasonPostPoneCancelListController = StreamController<BikerViewModel>();//StreamController<BikerViewModel>.broadcast();
  final reasonPostPoneCancelListSubject  = BehaviorSubject<FetchProcess>();
  Sink<BikerViewModel> get reasonPostPoneCancelListSink => reasonPostPoneCancelListController.sink;
  Stream<FetchProcess> get reasonPostPoneCancelListResult => reasonPostPoneCancelListSubject.stream;

  final postPoneCancelReasonController = StreamController<BikerViewModel>();
  final postPoneCancelReasonBehaviorSubject = BehaviorSubject<FetchProcess>();
  Sink<BikerViewModel> get postPoneCancelReasonSink => postPoneCancelReasonController.sink;
  Stream<FetchProcess> get  postPoneCancelReasonResult => postPoneCancelReasonBehaviorSubject.stream;

  ReasonPostPoneCancelBloc() {
    reasonPostPoneCancelListController.stream.listen(reasonUndeliveredApi);
    postPoneCancelReasonController.stream.listen(postPoneCancelReason);
  }

  void reasonUndeliveredApi(BikerViewModel bikerViewModel) async {
     FetchProcess process = new FetchProcess(loadingStatus: 1); //loading
     reasonPostPoneCancelListSubject.add(process);

     await bikerViewModel.getPostPonCancelReasonList();
     process.type = ApiType.performPostPoneCancelReasonList;

     process.loadingStatus = 2;
     process.networkServiceResponse = bikerViewModel.apiResult;
     process.statusCode = bikerViewModel.apiResult.responseCode;

     reasonPostPoneCancelListSubject.add(process);
     bikerViewModel = null;
  }

  void postPoneCancelReason(BikerViewModel bikerViewModel) async {
    FetchProcess process = new FetchProcess(loadingStatus: 1); //loading
    postPoneCancelReasonBehaviorSubject.add(process);

    //DISPATCH POSTPONE
    if (bikerViewModel.title == UIData.tabDispatch && bikerViewModel.reasonName == UIData.btnPostpone) {
      Map<String, dynamic> dispatchPostPoneParam = {
        "JOBID": bikerViewModel.inquiryNo,
        "POSTPONDRSN": bikerViewModel.selectReason,
        "POSTPONDATE": bikerViewModel.selectDate,
        "POSTPONTIME": bikerViewModel.selectTime.toUpperCase()
      };
      await bikerViewModel.getPostPoneCancelReason(dispatchPostPoneParam, bikerViewModel.title, bikerViewModel.reasonName);
    }
    //PICKUP POSTPONE
    else if (bikerViewModel.title == UIData.tabPickUp && bikerViewModel.reasonName == UIData.btnPostpone) {
      Map<String, dynamic> pickUpPostPoneParam = {
        "INQUIRYNO": bikerViewModel.inquiryNo,
        "POSTPONDRSN": bikerViewModel.selectReason,
        "PICKEDUPDATE": bikerViewModel.selectDate,
        "PICKEDUPTIME": bikerViewModel.selectTime
      };
      await bikerViewModel.getPostPoneCancelReason(pickUpPostPoneParam, bikerViewModel.title, bikerViewModel.reasonName);
    }
    //PICKUP CANCEL
    else if (bikerViewModel.title == UIData.tabPickUp && bikerViewModel.reasonName == UIData.btnCancel) {
      Map<String, dynamic> pickUpCancelParam = {
        "INQUIRYNO": bikerViewModel.inquiryNo,
        "Reason": bikerViewModel.selectReason
      };
      await bikerViewModel.getPostPoneCancelReason(pickUpCancelParam, bikerViewModel.title, bikerViewModel.reasonName);
    }

    process.type = ApiType.performPostPoneCancelReason;

    process.loadingStatus = 2;
    process.networkServiceResponse = bikerViewModel.apiResult;
    process.statusCode = bikerViewModel.apiResult.responseCode;

    if(process.statusCode == UIData.resCode200)
    {
      toast(bikerViewModel.reasonName.toLowerCase() +' successfull');
    }

    postPoneCancelReasonBehaviorSubject.add(process);
    bikerViewModel = null;
  }

  void dispose() {
    reasonPostPoneCancelListController.close();
    postPoneCancelReasonController.close();
    reasonPostPoneCancelListSubject.close();
    postPoneCancelReasonBehaviorSubject.close();
  }
}
