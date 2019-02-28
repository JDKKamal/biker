import 'dart:async';
import 'package:biker/logic/viewmodel/user_login_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:rxdart/rxdart.dart';

class ReasonUndeliveredBloc {
  final reasonUndeliveredController = StreamController<UserLoginViewModel>();

  Sink<UserLoginViewModel> get reasonUndeliveredSink => reasonUndeliveredController.sink;
  final apiController = BehaviorSubject<FetchProcess>();

  Stream<FetchProcess> get reasonUndeliveredResult => apiController.stream;

  ReasonUndeliveredBloc() {
    reasonUndeliveredController.stream.listen(reasonUndeliveredApi);
  }

  void reasonUndeliveredApi(UserLoginViewModel userLoginVM) async {
    FetchProcess process = new FetchProcess(loading: true); //loading
    apiController.add(process);

    await userLoginVM.getReasonUndelivered();
    process.type = ApiType.performReasonUndelivered;

    process.loading = false;
    process.response = userLoginVM.apiResult;
    process.statusCode = userLoginVM.apiResult.responseCode;

    //FOR ERROR DIALOG
    apiController.add(process);
    userLoginVM = null;
  }

  void dispose() {
    reasonUndeliveredController.close();
    apiController.close();
  }
}
