import 'dart:async';
import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:biker/logic/viewmodel/pickup_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/model/pickup/pickup_response.dart';
import 'package:biker/services/network_service_response.dart';
import 'package:biker/utils/uidata.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickUpBloc {
  List<PickUpResponse> pickUpList;
  FetchProcess process;
  BikerViewModel bikerViewModel;

  final pickUpListController = StreamController<BikerViewModel>();

  Sink<BikerViewModel> get pickUpListSink => pickUpListController.sink;
  final pickUpListBehaviorSubject = BehaviorSubject<FetchProcess>();

  Stream<FetchProcess> get pickUpListResult => pickUpListBehaviorSubject.stream;

  final pickUpDoneController = StreamController<BikerViewModel>();
  final pickUpDoneBehaviorSubject = BehaviorSubject<FetchProcess>();

  Sink<BikerViewModel> get pickUpDoneSink => pickUpDoneController.sink;

  Stream<FetchProcess> get pickUpDoneResult => pickUpDoneBehaviorSubject.stream;

  PickUpBloc() {
    pickUpListController.stream.listen(pickUpApi);
    pickUpDoneController.stream.listen(pickUpDoneReason);
  }

  void pickUpApi(BikerViewModel bikerViewModel) async {
    process = new FetchProcess(loadingStatus: 0); //loading
    pickUpListBehaviorSubject.add(process);

    var sharedPreferences = await SharedPreferences.getInstance();
    await bikerViewModel.getPickUp(sharedPreferences.getInt('id').toString());
    process.type = ApiType.performPickUp;

    process.loadingStatus = 0;

    process.networkServiceResponse = bikerViewModel.apiResult;
    process.statusCode = bikerViewModel.apiResult.responseCode;

    pickUpList = process.networkServiceResponse.response;

    pickUpListBehaviorSubject.add(process);
    bikerViewModel = null;
  }

  pickUpRemove(int position) async {
    pickUpList.removeWhere((item) => item.inquiryNo == position);

    NetworkServiceResponse<List<PickUpResponse>> networkServiceResponse =
        NetworkServiceResponse(response: pickUpList);
    process.networkServiceResponse = networkServiceResponse;
    pickUpListBehaviorSubject.add(process);
  }

  void pickUpDoneReason(BikerViewModel bikerViewModel) async {
    FetchProcess process = new FetchProcess(loadingStatus: 1);
    pickUpDoneBehaviorSubject.add(process);

    var nowDate = new DateTime.now();
    var patternDate = new DateFormat('yyyy-MM-dd');
    String formattedDate = patternDate.format(nowDate);

    DateTime nowTime = DateTime.now();
    String patternTime = DateFormat('kk:mma').format(nowTime);

    Map<String, dynamic> pickUpDone = {
      "INQUIRYNO": bikerViewModel.inquiryNo,
      "LNRPHONE": bikerViewModel.lonerPhone,
      "PICKEDUPDATE": formattedDate,
      "PICKEDUPTIME": patternTime.toString().toUpperCase()
    };

    await bikerViewModel.getPostPoneCancelReason(
        pickUpDone, bikerViewModel.title, bikerViewModel.reasonName);

    process.type = ApiType.performPostPoneCancelReason;

    process.loadingStatus = 2;
    process.networkServiceResponse = bikerViewModel.apiResult;
    process.statusCode = bikerViewModel.apiResult.responseCode;

    if (process.statusCode == UIData.resCode200) {
      pickUpRemove(int.parse(bikerViewModel.inquiryNo));
    }

    pickUpDoneBehaviorSubject.add(process);
    bikerViewModel = null;
  }

  void dispose() {
    pickUpListController.close();
    pickUpListBehaviorSubject.close();

    pickUpDoneController.close();
    pickUpDoneBehaviorSubject.close();
  }
}
