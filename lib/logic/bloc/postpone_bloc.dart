import 'dart:async';
import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostPoneBloc {
  final postPoneController = StreamController<BikerViewModel>();

  Sink<BikerViewModel> get postPoneSink => postPoneController.sink;
  final apiController = BehaviorSubject<FetchProcess>();

  Stream<FetchProcess> get postPoneResult => apiController.stream;

  PostPoneBloc() {
    postPoneController.stream.listen(postPoneApi);
  }

  void postPoneApi(BikerViewModel bikerViewModel) async {
    FetchProcess process = new FetchProcess(loadingStatus: 0); //loading
    apiController.add(process);

    var sharedPreferences = await SharedPreferences.getInstance();
    await bikerViewModel.getPostPone(sharedPreferences.getInt('id').toString());
    process.type = ApiType.performPostPone;

    process.loadingStatus = 0;
    process.networkServiceResponse = bikerViewModel.apiResult;
    process.statusCode = bikerViewModel.apiResult.responseCode;

    apiController.add(process);
    bikerViewModel = null;
  }

  void dispose() {
    postPoneController.close();
    apiController.close();
  }
}
