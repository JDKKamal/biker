import 'dart:async';
import 'package:biker/logic/viewmodel/user_login_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/model/pickup/pickup_response.dart';
import 'package:rxdart/rxdart.dart';

class PickUpBloc {
  final pickUpController = StreamController<UserLoginViewModel>();

  Sink<UserLoginViewModel> get pickUpSink => pickUpController.sink;
  final apiController = BehaviorSubject<FetchProcess>();

  Stream<FetchProcess> get pickUpResult => apiController.stream;
  List<PickUpResponse> pickUpList;

  PickUpBloc() {
    pickUpController.stream.listen(pickUpApi);
  }

  void pickUpApi(UserLoginViewModel userLoginVM) async {
    FetchProcess process = new FetchProcess(loading: true); //loading
    apiController.add(process);

    await userLoginVM.getPickUp('134');
    process.type = ApiType.performPickUp;

    process.loading = false;

    process.response = userLoginVM.apiResult;
    process.statusCode = userLoginVM.apiResult.responseCode;


    //FOR ERROR DIALOG
    apiController.add(process);
    userLoginVM = null;
  }

  deleteTask(int position) async {

  }


  void dispose() {
    pickUpController.close();
    apiController.close();

  }
}
