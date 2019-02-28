import 'dart:async';
import 'package:biker/logic/viewmodel/user_login_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:rxdart/rxdart.dart';

class DispatchBloc {
  final dispatchController = StreamController<UserLoginViewModel>();

  Sink<UserLoginViewModel> get dispatchSink => dispatchController.sink;
  final apiController = BehaviorSubject<FetchProcess>();

  Stream<FetchProcess> get dispatchResult => apiController.stream;

  DispatchBloc() {
    dispatchController.stream.listen(dispatchApi);
  }

  void dispatchApi(UserLoginViewModel userLoginVM) async {
    FetchProcess process = new FetchProcess(loading: true); //loading
    apiController.add(process);

    await userLoginVM.getDispatch('99');
    process.type = ApiType.performDispatch;

    process.loading = false;
    process.response = userLoginVM.apiResult;
    process.statusCode = userLoginVM.apiResult.responseCode;

    //FOR ERROR DIALOG
    apiController.add(process);
    userLoginVM = null;
  }

  void dispose() {
    dispatchController.close();
    apiController.close();
  }
}
