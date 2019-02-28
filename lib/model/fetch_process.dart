import 'package:biker/services/network_service_response.dart';

enum ApiType { performLogin, performPickUp, performDispatch, performPostPone, performReasonUndelivered, performReasonPostPoneCancel }

class FetchProcess<T> {
  ApiType type;
  bool loading;
  int statusCode = 0;
  NetworkServiceResponse<T> response;

  FetchProcess({this.loading, this.statusCode, this.response, this.type});
}
