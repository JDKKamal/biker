import 'dart:async';
import 'dart:io';
import 'package:biker/model/drawer/drawer_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerBloc {
  final userController = StreamController<DrawerResponse>();

  Stream<DrawerResponse> get user => userController.stream;

  DrawerBloc() {
    userData();
  }

  void userData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String photoPath = sharedPreferences.getString("profile");

    userController.add(DrawerResponse(
      empName: sharedPreferences.get('userName'),
      empMobile:sharedPreferences.get('mobile'),
      photo: photoPath.isEmpty ? null : new File(photoPath)
    ));
  }
}
