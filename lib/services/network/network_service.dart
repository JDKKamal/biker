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
import 'package:biker/utils/uidata.dart';

class NetworkService extends NetworkType implements APIService {
  static final _baseUrl = '';
  final _loginUrl = _baseUrl;

  //PICKUP - POSTPONE - DISPATCH LIST
  final _pickUpAssignListUrl = _baseUrl;
  final _postPoneAssignListUrl = _baseUrl;
  final _dispatchAssignListUrl = _baseUrl;

  //PICKUP - DISPATCH UNDELIVERED REASON LIST
  final _postPoneCancelReasonListUrl = _baseUrl;
  final _dispatchUndeliveredReasonListUrl = _baseUrl;

  //PICKUP CANCEL - DISPATCH RETURN
  final _pickUpCancelReasonUrl = _baseUrl ;
  final _dispatchUndeliveredReasonUrl = _baseUrl;

  //PICKUP - DISPATCH DONE
  final _pickUpDoneUrl = _baseUrl;
  final _dispatchDoneUrl = _baseUrl;

  //PICKUP - DISPATCH POSTPONE
  final _pickUpPostPoneReasonUrl = _baseUrl;
  final _dispatchPostPoneReasonUrl = _baseUrl;

  //DASHBOARD
  final _dashboardDataDispatch = _baseUrl;
  final _dashboardDataPickUp = _baseUrl;

  Map<String, String> headers = {
    "Content-Type": 'application/json',
    "": '',
  };

  NetworkService(RestClient rest) : super(rest);

  @override
  Future<NetworkServiceResponse<LoginResponse>> login(String phoneNumber, String password) async {
    var result = await rest.get<LoginResponse>('$_loginUrl?MobileNo=$phoneNumber&Password=$password&DeviceId=""',
        headers);
    if (result.mappedResult != null) {
      var res = LoginResponse.fromJson(json.decode(result.mappedResult));
      return new NetworkServiceResponse(
        response: res,
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
    if (result.networkServiceResponse.responseCode == UIData.resCode200) {
      List<PickUpResponse> list = (json.decode(result.mappedResult) as List)
          .map((data) => new PickUpResponse.fromJson(data))
          .toList();
      return new NetworkServiceResponse(
        response: list,
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
    if (result.networkServiceResponse.responseCode == UIData.resCode200) {
      List<DispatchResponse> list = (json.decode(result.mappedResult) as List)
          .map((data) => new DispatchResponse.fromJson(data))
          .toList();
      return new NetworkServiceResponse(
        response: list,
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
    if (result.networkServiceResponse.responseCode == UIData.resCode200) {
      List<PostPoneResponse> list = (json.decode(result.mappedResult) as List)
          .map((data) => new PostPoneResponse.fromJson(data))
          .toList();
      return new NetworkServiceResponse(
        response: list,
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message,
      );
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<List<ReasonResponse>>> undeliveredReasonList() async{
    var result = await rest.get<ReasonResponse>('$_dispatchUndeliveredReasonListUrl',  headers);
    if (result.networkServiceResponse.responseCode == UIData.resCode200) {
      List<ReasonResponse> list = (json.decode(result.mappedResult) as List)
          .map((data) => new ReasonResponse.fromJson(data))
          .toList();
      return new NetworkServiceResponse(
        response: list,
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message,
      );
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<List<ReasonResponse>>> postPonCancelReasonList() async {
    var result = await rest.get<ReasonResponse>('$_postPoneCancelReasonListUrl',  headers);
    if (result.networkServiceResponse.responseCode == UIData.resCode200) {
      List<ReasonResponse> list = (json.decode(result.mappedResult) as List)
          .map((data) => new ReasonResponse.fromJson(data))
          .toList();
      return new NetworkServiceResponse(
        response: list,
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message,
      );
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse> postPoneCancelReason(Map<String, dynamic> postPoneCancelReasonBody, String title, String reasonName) async{
    var result;
    //PICKUP DONE
    if (title == UIData.tabPickUp && reasonName == UIData.btnDone) {
      result = await rest.post<ReasonResponse>('$_pickUpDoneUrl', headers: headers, body: json.encode(postPoneCancelReasonBody));
    }

    //PICKUP POSTPONE
    else if (title == UIData.tabPickUp && reasonName == UIData.btnPostpone) {
      result = await rest.post<ReasonResponse>('$_pickUpPostPoneReasonUrl', headers: headers, body: json.encode(postPoneCancelReasonBody));
    }

    //PICKUP CANCEL
    else if (title == UIData.tabPickUp && reasonName == UIData.btnCancel) {
      result = await rest.post<ReasonResponse>('$_pickUpCancelReasonUrl', headers: headers, body: json.encode(postPoneCancelReasonBody));
    }

    //DISPATCH DONE
    else if (title == UIData.tabDispatch && reasonName == UIData.btnDone) {
      result = await rest.post<ReasonResponse>('$_dispatchDoneUrl', headers: headers, body: json.encode(postPoneCancelReasonBody));
    }

    //DISPATCH POSTPONE
    else if (title == UIData.tabDispatch && reasonName == UIData.btnPostpone) {
      result = await rest.post<ReasonResponse>('$_dispatchPostPoneReasonUrl', headers: headers, body: json.encode(postPoneCancelReasonBody));
    }

    //DISPATCH UNDELIVERED
    else if (title == UIData.tabDispatch && reasonName == UIData.btnUndelivered) {
      result = await rest.post<ReasonResponse>('$_dispatchUndeliveredReasonUrl', headers: headers, body: json.encode(postPoneCancelReasonBody));
    }

    if (result.networkServiceResponse.responseCode == UIData.resCode200) {
      return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message,
      );
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode,
        message: result.networkServiceResponse.message);
  }
}
