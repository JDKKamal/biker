import 'dart:async';
import 'package:intl/intl.dart';
import 'package:biker/logic/viewmodel/user_login_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/model/login/login_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc {
  final loginController = StreamController<UserLoginViewModel>();

  Sink<UserLoginViewModel> get loginSink => loginController.sink;
  final apiController = BehaviorSubject<FetchProcess>();

  Stream<FetchProcess> get apiResult => apiController.stream;

  LoginBloc() {
    loginController.stream.listen(apiCall);
  }

  void apiCall(UserLoginViewModel userLogin) async {
    FetchProcess process = new FetchProcess(loading: true); //loading
    apiController.add(process);

    await userLogin.getLogin(userLogin.phoneNumber, userLogin.password);
    process.type = ApiType.performLogin;

    process.loading = false;
    process.response = userLogin.apiResult;
    process.statusCode = userLogin.apiResult.responseCode;

    if (process.statusCode == 200) {
      LoginResponse loginResponse = process.response.content;
      DateTime nowDateTime = DateTime.now();
      String patternDateTime =
          DateFormat('yyyy-MM-dd kk:mm a').format(nowDateTime);

      var sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('profile', "");

      sharedPreferences.setString('mobile', loginResponse.empMobile);
      sharedPreferences.setString('userName', loginResponse.empName);
      sharedPreferences.setInt('id', loginResponse.empId);
      sharedPreferences.setString('loginTime', patternDateTime);
    }
    //FOR ERROR DIALOG
    apiController.add(process);
    userLogin = null;
  }

  void dispose() {
    loginController.close();
    apiController.close();
  }
}
