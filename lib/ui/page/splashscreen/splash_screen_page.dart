import 'dart:async';
import 'package:biker/ui/page/tab/postpone_undelivered_reason.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biker/ui/page/login/login_page.dart';
import 'package:biker/ui/page/tab/tab_delivery.dart';
import 'package:biker/ui/widgets/login_background.dart';
import 'package:biker/utils/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  createState() => new _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Duration five;
  Timer t2;
  String routeName;

  @override
  void initState() {
    super.initState();
    five = const Duration(seconds: 3);
    t2 = new Timer(five, () {
      getCredential();
    });
  }

  @override
  void dispose() {
    if (this.mounted)
    super.dispose();
    t2.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          LoginBackground(
            showIcon: true,
          ),
          Container(
              height: double.infinity,
              width: double.infinity,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: new Text(
                      UIData.appName,
                      style: new TextStyle(color: Colors.orange, fontSize: 40),
                    ),
                  ),
                ],
              )),
        ],
      ),
      bottomNavigationBar: new Container(
          width: MediaQuery.of(context).size.width, child: companyName()),
    );
  }

  companyName() => Padding(
    padding: EdgeInsets.all(8.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      //mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Text('Release: 19-02-2019',
            style: TextStyle( color: Colors.black45,
                fontSize: 13.0,
                fontWeight: FontWeight.bold)),
      ],
    ),
  );

  getCredential() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("mobile") == null) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new LoginPage()));
    } else {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new TabDelivery()));
    }
  }
}
