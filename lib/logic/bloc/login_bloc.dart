import 'dart:async';
import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:biker/utils/uidata.dart';
import 'package:intl/intl.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/model/login/login_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc {
  final loginController = StreamController<BikerViewModel>();

  Sink<BikerViewModel> get loginSink => loginController.sink;
  final apiController = BehaviorSubject<FetchProcess>();

  Stream<FetchProcess> get apiResult => apiController.stream;

  LoginBloc() {
    loginController.stream.listen(apiCall);
  }

  void apiCall(BikerViewModel bikerViewModel) async {
    FetchProcess process = new FetchProcess(loadingStatus: 1); //loading
    apiController.add(process);

    await bikerViewModel.getLogin(bikerViewModel.phoneNumber, bikerViewModel.password);
    process.type = ApiType.performLogin;

    process.loadingStatus = 2;
    process.networkServiceResponse = bikerViewModel.apiResult;
    process.statusCode = bikerViewModel.apiResult.responseCode;

    if (process.statusCode == UIData.resCode200) {
      LoginResponse loginResponse = process.networkServiceResponse.response;
      DateTime nowDateTime = DateTime.now();
      String patternDateTime = DateFormat('yyyy-MM-dd kk:mm a').format(nowDateTime);

      var sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('profile', "");

      sharedPreferences.setString('mobile', loginResponse.empMobile);
      sharedPreferences.setString('userName', loginResponse.empName);
      sharedPreferences.setInt('id', loginResponse.empId);
      sharedPreferences.setString('loginTime', patternDateTime);
    }

    apiController.add(process);
    bikerViewModel = null;
  }

  void dispose() {
    loginController.close();
    apiController.close();
  }
}
