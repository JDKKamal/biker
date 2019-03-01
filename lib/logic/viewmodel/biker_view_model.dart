import 'dart:async';

import 'package:biker/di/dependency_injection.dart';
import 'package:biker/model/dispatch/dispatch_response.dart';
import 'package:biker/model/login/login_response.dart';
import 'package:biker/model/pickup/pickup_response.dart';
import 'package:biker/model/postpone/postpone_response.dart';
import 'package:biker/model/reason/reason.dart';
import 'package:biker/services/abstract/api_service.dart';
import 'package:biker/services/network_service_response.dart';
import 'package:meta/meta.dart';

class BikerViewModel {
  String userId, phoneNumber, password, title, reasonName, lonerPhone, selectReason, inquiryNo, selectDate, selectTime;
  NetworkServiceResponse apiResult;
  APIService apiService = new Injector().otpService;

  BikerViewModel.delivery();

  BikerViewModel.deliveryOption({
    @required this.title,
    @required this.reasonName,
    this.lonerPhone,
    @required this.inquiryNo,
    @required this.selectReason,
    this.selectDate,
    this.selectTime
  });

  BikerViewModel.login({@required this.phoneNumber, @required this.password});

  Future<Null> getLogin(String phoneNumber, String password) async {
    NetworkServiceResponse<LoginResponse> result =
    await apiService.login(phoneNumber, password);
    this.apiResult = result;
  }

  Future<Null> getPickUp(String userId) async {
    NetworkServiceResponse<List<PickUpResponse>> result =
    await apiService.pickUp(userId);
    this.apiResult = result;
  }

  Future<Null> getDispatch(String userId) async {
    NetworkServiceResponse<List<DispatchResponse>> result =
    await apiService.dispatch(userId);
    this.apiResult = result;
  }

  Future<Null> getPostPone(String userId) async {
    NetworkServiceResponse<List<PostPoneResponse>> result =
    await apiService.postpone(userId);
    this.apiResult = result;
  }

  Future<Null> getUndeliveredReasonList() async {
    NetworkServiceResponse<List<ReasonResponse>> result =
    await apiService.undeliveredReasonList();
    this.apiResult = result;
  }

  Future<Null> getPostPonCancelReasonList() async {
    NetworkServiceResponse<List<ReasonResponse>> result =
    await apiService.postPonCancelReasonList();
    this.apiResult = result;
  }

  Future<Null> getPostPoneCancelReason(Map<String, dynamic> postPoneCancelReasonBody, String title, String reasonName) async {
    NetworkServiceResponse result = await apiService.postPoneCancelReason(postPoneCancelReasonBody, title, reasonName);
    this.apiResult = result;
  }
}
