import 'dart:async';
import 'package:biker/logic/viewmodel/user_login_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:rxdart/rxdart.dart';

class ReasonPostPoneCancelBloc {
  final reasonPostPoneCancelController = StreamController<UserLoginViewModel>();

  Sink<UserLoginViewModel> get reasonPostPoneCancelSink => reasonPostPoneCancelController.sink;
  final apiController = BehaviorSubject<FetchProcess>();

  Stream<FetchProcess> get reasonPostPoneCancelResult => apiController.stream;

  ReasonPostPoneCancelBloc() {
    reasonPostPoneCancelController.stream.listen(reasonUndeliveredApi);
  }

  void reasonUndeliveredApi(UserLoginViewModel userLoginVM) async {
    FetchProcess process = new FetchProcess(loading: true); //loading
    apiController.add(process);

    await userLoginVM.getReasonPostPoneCancel();
    process.type = ApiType.performReasonPostPoneCancel;

    process.loading = false;
    process.response = userLoginVM.apiResult;
    process.statusCode = userLoginVM.apiResult.responseCode;

    //FOR ERROR DIALOG
    apiController.add(process);
    userLoginVM = null;
  }

  void dispose() {
    reasonPostPoneCancelController.close();
    apiController.close();
  }
}
