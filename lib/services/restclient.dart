import 'dart:async';
import 'package:biker/services/network_service_response.dart';
import 'package:http/http.dart' as http;
import 'package:biker/utils/uidata.dart';

class RestClient {
  Future<MappedNetworkServiceResponse<T>> get<T>(String url, Map headers) async{
    try {
      var response = await http.get(url, headers: headers);
      return processResponse<T>(response);
    }
    catch(e)
    {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: 0,
              message: "${"Internal server error"}"));
    }
  }

  MappedNetworkServiceResponse<T> processResponse<T>(http.Response response) {
    if ((response.statusCode > UIData.resCode200)) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: response.statusCode,
              message: "(${response.statusCode}) ${response.body}"));
    } else {
      return new MappedNetworkServiceResponse<T>(
          mappedResult: response.body,
          networkServiceResponse:
          new NetworkServiceResponse<T>(responseCode: response.statusCode));
    }
  }
}
