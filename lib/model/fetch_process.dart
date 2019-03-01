import 'package:biker/services/network_service_response.dart';

enum ApiType { performLogin, performPickUp, performDispatch, performPostPone, performUndeliveredReasonList, performPostPoneCancelReasonList, performPostPoneCancelReason }

class FetchProcess<T> {
  ApiType type;
  int loadingStatus = 0;
  int statusCode = 0;
  NetworkServiceResponse<T> networkServiceResponse;

  FetchProcess({this.loadingStatus, this.statusCode, this.networkServiceResponse, this.type});
}
