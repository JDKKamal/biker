import 'dart:async';

import 'package:biker/model/dispatch/dispatch_response.dart';
import 'package:biker/model/login/login_response.dart';
import 'package:biker/model/pickup/pickup_response.dart';
import 'package:biker/model/postpone/postpone_response.dart';
import 'package:biker/model/reason/reason.dart';
import 'package:biker/services/network_service_response.dart';

abstract class APIService {
  Future<NetworkServiceResponse<LoginResponse>> login(String phoneNumber, String password);
  Future<NetworkServiceResponse<List<PickUpResponse>>> pickUp(String userID);
  Future<NetworkServiceResponse<List<DispatchResponse>>> dispatch(String userID);
  Future<NetworkServiceResponse<List<PostPoneResponse>>> postpone(String userID);
  Future<NetworkServiceResponse<List<ReasonResponse>>> undeliveredReasonList();
  Future<NetworkServiceResponse<List<ReasonResponse>>> postPonCancelReasonList();

  Future<NetworkServiceResponse> postPoneCancelReason(Map<String, dynamic> postPoneCancelReasonBody, String title, String reasonName);
}
