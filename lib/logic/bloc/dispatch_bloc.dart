import 'dart:async';
import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:biker/model/dispatch/dispatch_response.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/services/network_service_response.dart';
import 'package:biker/utils/uidata.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DispatchBloc {
  FetchProcess process;
  List<DispatchResponse> dispatchList;

  final dispatchListController = StreamController<BikerViewModel>();

  Sink<BikerViewModel> get dispatchListSink => dispatchListController.sink;
  final dispatchListBehaviorSubject = BehaviorSubject<FetchProcess>();

  Stream<FetchProcess> get dispatchListResult =>
      dispatchListBehaviorSubject.stream;

  final dispatchDoneController = StreamController<BikerViewModel>();
  final dispatchDoneBehaviorSubject = BehaviorSubject<FetchProcess>();

  Sink<BikerViewModel> get dispatchDoneSink => dispatchDoneController.sink;

  Stream<FetchProcess> get dispatchDoneResult =>
      dispatchDoneBehaviorSubject.stream;

  DispatchBloc() {
    dispatchListController.stream.listen(dispatchApi);
    dispatchDoneController.stream.listen(dispatchDoneReason);
  }

  void dispatchApi(BikerViewModel bikerViewModel) async {
    process = new FetchProcess(loadingStatus: 0); //loading

    var sharedPreferences = await SharedPreferences.getInstance();
    await bikerViewModel.getDispatch(sharedPreferences.getInt('id').toString());
    process.type = ApiType.performDispatch;

    process.loadingStatus = 0;
    process.networkServiceResponse = bikerViewModel.apiResult;
    process.statusCode = bikerViewModel.apiResult.responseCode;

    dispatchList = process.networkServiceResponse.response;

    dispatchListBehaviorSubject.add(process);
    bikerViewModel = null;
  }

  void dispatchDoneReason(BikerViewModel bikerViewModel) async {
    FetchProcess process = new FetchProcess(loadingStatus: 1); //loading
    dispatchDoneBehaviorSubject.add(process);

    var nowDate = new DateTime.now();
    var patternDate = new DateFormat('yyyy-MM-dd');
    String formattedDate = patternDate.format(nowDate);

    DateTime nowTime = DateTime.now();
    String patternTime = DateFormat('kk:mma').format(nowTime);

    Map<String, dynamic> dispatchDone = {
      "JOBID": bikerViewModel.inquiryNo,
      "COLLECTLNRPH": bikerViewModel.lonerPhone,
      "DELIDATE": formattedDate,
      "DELITIME": patternTime.toString().toUpperCase()
    };

    await bikerViewModel.getPostPoneCancelReason(
        dispatchDone, bikerViewModel.title, bikerViewModel.reasonName);

    process.type = ApiType.performPostPoneCancelReason;

    process.loadingStatus = 2;
    process.networkServiceResponse = bikerViewModel.apiResult;
    process.statusCode = bikerViewModel.apiResult.responseCode;

    if (process.statusCode == UIData.resCode200) {
      dispatchRemove(bikerViewModel.inquiryNo);
    }

    dispatchDoneBehaviorSubject.add(process);
    bikerViewModel = null;
  }

  dispatchRemove(String position) async {
    dispatchList.removeWhere((item) => item.jobId == position);

    NetworkServiceResponse<List<DispatchResponse>> networkServiceResponse =
        NetworkServiceResponse(response: dispatchList);
    process.networkServiceResponse = networkServiceResponse;
    dispatchListBehaviorSubject.add(process);
  }

  void dispose() {
    dispatchListController.close();
    dispatchListBehaviorSubject.close();

    dispatchDoneController.close();
    dispatchDoneBehaviorSubject.close();
  }
}
