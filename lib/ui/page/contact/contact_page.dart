import 'package:biker/ui/page/contact/contact_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biker/ui/widgets/common_scaffold.dart';
import 'package:biker/ui/widgets/login_background.dart';

class ContactPage extends StatelessWidget {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  Widget bodyData() => Stack(
    fit: StackFit.expand,
    children: <Widget>[
      LoginBackground(
        showIcon: false,
      ),
      ContactWidget(),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  Widget _scaffold() => CommonScaffold(
    backGroundColor: Colors.grey.shade100,
    actionFirstIcon: null,
    appTitle: "Contact Us",
    scaffoldKey: _scaffoldState,
    bodyData: bodyData(),
  );
}
