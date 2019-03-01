import 'dart:async';

import 'package:biker/logic/viewmodel/dispatch_view_model.dart';
import 'package:biker/logic/viewmodel/pickup_view_model.dart';
import 'package:biker/logic/viewmodel/postpone_view_model.dart';
import 'package:biker/logic/viewmodel/reason_postpone_cancel_view_model.dart';
import 'package:biker/logic/viewmodel/reason_undelivered_view_model.dart';
import 'package:biker/model/dispatch/dispatch_response.dart';
import 'package:biker/model/login/login_response.dart';
import 'package:biker/model/pickup/pickup_response.dart';
import 'package:biker/model/postpone/postpone_response.dart';
import 'package:biker/model/reason/reason.dart';
import 'package:biker/services/abstract/api_service.dart';
import 'package:biker/services/network_service_response.dart';
import 'package:biker/utils/uidata.dart';

class MockService implements APIService {

  @override
  Future<NetworkServiceResponse<LoginResponse>> login(String phoneNumber, String password) async {
    await Future.delayed(Duration(seconds: 2));
    return Future.value(NetworkServiceResponse(
        responseCode: UIData.resCode200,
        response:  LoginResponse(
          empId: 000,
          empName: 'Lakhani kamlesh',
          empMobile: '9586331823',
          message:  UIData.msgLoginSuccessfully,
        ),
        message: UIData.msgLoginSuccessfully));
  }

  @override
  Future<NetworkServiceResponse<List<DispatchResponse>>> dispatch(String userID) {
    final _dispatchVM = DispatchViewModel();
    return Future.value(NetworkServiceResponse(
        responseCode: UIData.resCode200,
        response: _dispatchVM.getDispatch(),
        message: UIData.get_data));
  }

  @override
  Future<NetworkServiceResponse<List<PostPoneResponse>>> postpone(String userID) {
    final _postPoneVM = PostPoneViewModel();
    return Future.value(NetworkServiceResponse(
        responseCode: UIData.resCode200,
        response: _postPoneVM.getPostPone(),
        message: UIData.get_data));
  }

  @override
  Future<NetworkServiceResponse<List<ReasonResponse>>> undeliveredReasonList() async{
   // await Future.delayed(Duration(seconds: 2));
    final _reasonUndeliveredVM = ReasonUndeliveredViewModel();
    return Future.value(NetworkServiceResponse(
        responseCode: UIData.resCode200,
        response: _reasonUndeliveredVM.getReasonUndelivered(),
        message: UIData.get_data));
  }

  @override
  Future<NetworkServiceResponse<List<ReasonResponse>>> postPonCancelReasonList() async{
   // await Future.delayed(Duration(seconds: 2));
    final _reasonPostPoneCancelVM = ReasonPostPoneCancelViewModel();
    return Future.value(NetworkServiceResponse(
        responseCode: UIData.resCode200,
        response: _reasonPostPoneCancelVM.getReasonPostPoneCancel(),
        message: UIData.get_data));
  }

  @override
  Future<NetworkServiceResponse<List<PickUpResponse>>> pickUp(String userID) {
    final _pickUpVM = PickUpViewModel();
    return Future.value(NetworkServiceResponse(
        responseCode: UIData.resCode200,
        response: _pickUpVM.getPickUp(),
        message: UIData.get_data));
  }

  @override
  Future<NetworkServiceResponse> postPoneCancelReason(Map<String, dynamic> postPoneCancelReasonBody, String title, String reasonName) async{
    await Future.delayed(Duration(seconds: 2));
    print("Tag" + postPoneCancelReasonBody.toString() +' - '+ title +' - '+ reasonName);
    return Future.value(NetworkServiceResponse(
        responseCode: UIData.resCode200,
        response: null,
        message: title +' '+ reasonName.toLowerCase() + ' successfull'));
  }
}

