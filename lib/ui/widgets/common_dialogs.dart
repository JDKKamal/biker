import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:biker/services/network_service_response.dart';
import 'package:biker/utils/uidata.dart';

fetchApiResult(BuildContext context, NetworkServiceResponse snapshot) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
          title:
          Center(child: Text(UIData.error, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red.withOpacity(0.7), fontSize: 18.0))),
          content: Text(snapshot.message, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black54, fontSize: 15.0)),
          actions: <Widget>[
            FlatButton(
              child: Text(UIData.ok, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.orange, fontSize: 15.0)),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
  );
}

toast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.black);
}

showSuccess(BuildContext context, String message, IconData icon) {
  showDialog(
      context: context,
      builder: (context) => Center(
            child: Material(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.black,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Colors.green,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      message,
                      style: TextStyle(
                          fontFamily: UIData.ralewayFont, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ));
}

showProgress(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orange,
            ),
          ));
}

hideProgress(BuildContext context) {
  Navigator.pop(context);
}
