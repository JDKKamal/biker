class NetworkServiceResponse<T> {
  T response;
  int responseCode;
  String message;

  NetworkServiceResponse({this.response, this.responseCode, this.message});
}

class MappedNetworkServiceResponse<T> {
  dynamic mappedResult;
  NetworkServiceResponse<T> networkServiceResponse;
  MappedNetworkServiceResponse(
      {this.mappedResult, this.networkServiceResponse});
}
