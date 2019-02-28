class NetworkServiceResponse<T> {
  T content;
  int responseCode;
  String message;

  NetworkServiceResponse({this.content, this.responseCode, this.message});
}

class MappedNetworkServiceResponse<T> {
  dynamic mappedResult;
  NetworkServiceResponse<T> networkServiceResponse;
  MappedNetworkServiceResponse(
      {this.mappedResult, this.networkServiceResponse});
}
