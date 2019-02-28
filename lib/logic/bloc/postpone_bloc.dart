import 'dart:async';
import 'package:biker/logic/viewmodel/user_login_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:rxdart/rxdart.dart';

class PostPoneBloc {
  final postPoneController = StreamController<UserLoginViewModel>();

  Sink<UserLoginViewModel> get postPoneSink => postPoneController.sink;
  final apiController = BehaviorSubject<FetchProcess>();

  Stream<FetchProcess> get postPoneResult => apiController.stream;

  PostPoneBloc() {
    postPoneController.stream.listen(postPoneApi);
  }

  void postPoneApi(UserLoginViewModel userLoginVM) async {
    FetchProcess process = new FetchProcess(loading: true); //loading
    apiController.add(process);

    await userLoginVM.getPostPone('99');
    process.type = ApiType.performPostPone;

    process.loading = false;
    process.response = userLoginVM.apiResult;
    process.statusCode = userLoginVM.apiResult.responseCode;

    //FOR ERROR DIALOG
    apiController.add(process);
    userLoginVM = null;
  }

  void dispose() {
    postPoneController.close();
    apiController.close();
  }
}
