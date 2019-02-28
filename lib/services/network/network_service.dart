import 'dart:async';
import 'dart:convert';

import 'package:biker/model/dispatch/dispatch_response.dart';
import 'package:biker/model/login/login_response.dart';
import 'package:biker/model/pickup/pickup_response.dart';
import 'package:biker/model/postpone/postpone_response.dart';
import 'package:biker/model/reason/reason.dart';
import 'package:biker/services/abstract/api_service.dart';
import 'package:biker/services/network_type.dart';
import 'package:biker/services/network_service_response.dart';
import 'package:biker/services/restclient.dart';

class NetworkService extends NetworkType implements APIService {
  static final _baseUrl = "";
  final _loginUrl = _baseUrl + "";
  final _pickUpAssignListUrl = _baseUrl + "";
  final _postPoneAssignListUrl = _baseUrl + "";
  final _dispatchAssignListUrl = _baseUrl + "";
  final _reasonPostPoneCancelListUrl = _baseUrl + "";
  final _pickUpDoneUrl = _baseUrl + "";
  final _pickUpPostPoneUrl = _baseUrl + "";
  final _pickUpCancelUrl = _baseUrl + "";

  final _dispatchDoneUrl = _baseUrl + "";
  final _dispatchPostPoneUrl = _baseUrl + "";
  final _dispatchReasonUndeliveredListUrl = _baseUrl + "";

  final _dashboardDataDispatch = _baseUrl + "";
  final _dashboardDataPickUp = _baseUrl + "";

  Map<String, String> headers = {
    "Content-Type": 'application/json',
    "AUTH_KEY": '',
  };

  NetworkService(RestClient rest) : super(rest);

  @override
  Future<NetworkServiceResponse<LoginResponse>> login(String phoneNumber, String password) async {
    var result = await rest.get<LoginResponse>('$_loginUrl?MobileNo=$phoneNumber&Password=$password&DeviceId=""',
        headers);
    if (result.mappedResult != null) {
      var res = LoginResponse.fromJson(json.decode(result.mappedResult));
      return new NetworkServiceResponse(
        content: res,
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message,
      );
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<List<PickUpResponse>>> pickUp(String userId) async {
    var result = await rest.get<PickUpResponse>('$_pickUpAssignListUrl?EMPID=$userId', headers);
    if (result.networkServiceResponse.responseCode == 200) {
      List<PickUpResponse> list = (json.decode(result.mappedResult) as List)
          .map((data) => new PickUpResponse.fromJson(data))
          .toList();
      return new NetworkServiceResponse(
        content: list,
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message,
      );
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<List<DispatchResponse>>> dispatch(String userId) async{
    var result = await rest.get<DispatchResponse>('$_dispatchAssignListUrl?EMPID=$userId', headers);
    if (result.networkServiceResponse.responseCode == 200) {
      List<DispatchResponse> list = (json.decode(result.mappedResult) as List)
          .map((data) => new DispatchResponse.fromJson(data))
          .toList();
      return new NetworkServiceResponse(
        content: list,
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message,
      );
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<List<PostPoneResponse>>> postpone(String userId) async {
    var result = await rest.get<DispatchResponse>('$_postPoneAssignListUrl?EMPID=$userId', headers);
    if (result.networkServiceResponse.responseCode == 200) {
      List<PostPoneResponse> list = (json.decode(result.mappedResult) as List)
          .map((data) => new PostPoneResponse.fromJson(data))
          .toList();
      return new NetworkServiceResponse(
        content: list,
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message,
      );
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<List<ReasonResponse>>> reasonUndelivered() async{
    var result = await rest.get<ReasonResponse>('$_dispatchReasonUndeliveredListUrl',  headers);
    if (result.mappedResult != null) {
      List<ReasonResponse> list = (json.decode(result.mappedResult) as List)
          .map((data) => new ReasonResponse.fromJson(data))
          .toList();
      return new NetworkServiceResponse(
        content: list,
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message,
      );
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<List<ReasonResponse>>> reasonPostPonCancel() async {
    var result = await rest.get<ReasonResponse>('$_reasonPostPoneCancelListUrl',  headers);
    if (result.networkServiceResponse.responseCode == 200) {
      List<ReasonResponse> list = (json.decode(result.mappedResult) as List)
          .map((data) => new ReasonResponse.fromJson(data))
          .toList();
      return new NetworkServiceResponse(
        content: list,
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message,
      );
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message);
  }
}
