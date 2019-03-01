import 'dart:async';
import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/ui/widgets/common_dialogs.dart';
import 'package:biker/utils/uidata.dart';
import 'package:rxdart/rxdart.dart';

class ReasonUndeliveredBloc {
  final reasonUndeliveredController = StreamController<BikerViewModel>();
  Sink<BikerViewModel> get undeliveredReasonListSink => reasonUndeliveredController.sink;
  final  undeliveredReasonListBehaviorSubject = BehaviorSubject<FetchProcess>();
  Stream<FetchProcess> get undeliveredReasonListResult => undeliveredReasonListBehaviorSubject.stream;

  final undeliveredReasonController = StreamController<BikerViewModel>();
  final undeliveredReasonBehaviorSubject = BehaviorSubject<FetchProcess>();
  Sink<BikerViewModel> get undeliveredReasonBehaviorSubjectSink => undeliveredReasonController.sink;
  Stream<FetchProcess> get undeliveredReasonBehaviorSubjectResult => undeliveredReasonBehaviorSubject.stream;


  ReasonUndeliveredBloc() {
    reasonUndeliveredController.stream.listen(undeliveredReasonListApi);
    undeliveredReasonController.stream.listen(undeliveredReason);
  }

  void undeliveredReasonListApi(BikerViewModel bikerViewModel) async {
    FetchProcess process = new FetchProcess(loadingStatus: 1); //loading
    undeliveredReasonListBehaviorSubject.add(process);

    await bikerViewModel.getUndeliveredReasonList();
    process.type = ApiType.performUndeliveredReasonList;

    process.loadingStatus = 2;
    process.networkServiceResponse = bikerViewModel.apiResult;
    process.statusCode = bikerViewModel.apiResult.responseCode;

    undeliveredReasonListBehaviorSubject.add(process);
    bikerViewModel = null;
  }

  void undeliveredReason(BikerViewModel bikerViewModel) async {
    FetchProcess process = new FetchProcess(loadingStatus: 1); //loading
    undeliveredReasonBehaviorSubject.add(process);

    Map<String, dynamic> pickUpCancelParam = {
        "JOBNO": bikerViewModel.inquiryNo,
        "RETURNREASON": bikerViewModel.selectReason
    };
   await bikerViewModel.getPostPoneCancelReason(pickUpCancelParam, bikerViewModel.title, bikerViewModel.reasonName);

    process.type = ApiType.performPostPoneCancelReason;

    process.loadingStatus = 2;
    process.networkServiceResponse = bikerViewModel.apiResult;
    process.statusCode = bikerViewModel.apiResult.responseCode;

    if(process.statusCode == UIData.resCode200)
    {
      toast(bikerViewModel.reasonName.toLowerCase() +' successfull');
    }

    undeliveredReasonBehaviorSubject.add(process);
    bikerViewModel = null;
  }

  void dispose() {
    reasonUndeliveredController.close();
    undeliveredReasonListBehaviorSubject.close();
    undeliveredReasonController.close();
    undeliveredReasonBehaviorSubject.close();
  }
}
