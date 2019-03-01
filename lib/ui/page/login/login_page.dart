import 'dart:async';

import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:flutter/material.dart';
import 'package:biker/logic/bloc/login_bloc.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/services/network/api_subscription.dart';
import 'package:biker/ui/widgets/background_clipper.dart';
import 'package:biker/ui/widgets/custom_float_form.dart';
import 'package:biker/utils/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_shifter/mask_shifter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _key = new GlobalKey();
  final TextEditingController _mobileController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  LoginBloc loginBloc;
  StreamSubscription<FetchProcess> apiStreamSubscription;

  bool _validate = false;
  bool _obscureText = true;
  String mobile, password;

  @override
  void initState() {
    super.initState();

    loginBloc = new LoginBloc();
    apiStreamSubscription = apiSubscription(loginBloc.apiResult, context);

    /*final QuickActions quickActions = const QuickActions();
    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'action_contact_us') {
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'action_contact_us', localizedTitle: 'Contact us', icon: 'AppIcon'),
    ]);*/
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: new Container(
          width: MediaQuery
              .of(context)
              .size
              .width, child: signUp()),
      body: new Form(
          key: _key, autovalidate: _validate, child: loginBody(context)),
    );
  }

  loginBody(BuildContext context) =>
      ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[loginHeader(), formUI()],
      );

  @override
  void dispose() {
    if (this.mounted) super.dispose();

    loginBloc?.dispose();
    apiStreamSubscription?.cancel();

    _mobileController.dispose();
    _passwordController.dispose();
  }

  loginHeader() =>
      Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 60.0,
          ),
          Text(
            '${UIData.titleWelcome + " " + UIData.appName}',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.orange,
                fontSize: 22.0),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            '${UIData.titleSignInContinue}',
            style: TextStyle(color: Colors.grey, fontSize: 18.0),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      );

  formUI() {
    return new Container(
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: BackgroundClipper(),
            child: Container(
              height: 400,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 90.0,
                  ),
                  _showMobileInput(),
                  _showPasswordInput(),
                  new SizedBox(height: 10.0),
                  _showForgotPasswordButton(),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          _showFormIcon(false),
          _showLoginPressIcon(),
        ],
      ),
    );
  }

  _showMobileInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
      child: new TextFormField(
          controller: _mobileController,
          decoration: new InputDecoration(
            hintText: '${UIData.inputHintMobile}',
            labelText: '${UIData.inputLabelMobile}',

            /*suffixIcon: GestureDetector(
                            onTap: () {

                            },
                            child: Icon(Icons.keyboard_arrow_right),
                          ),*/
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            MaskedTextInputFormatterShifter(
                maskONE: "XXX XXX XXXX", maskTWO: "XXX XXX XXXX"),
          ],
          validator: UIData.validateMobile,
          onSaved: (String val) {
            mobile = val;
          }),
    );
  }

  _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
      child: new TextFormField(
          controller: _passwordController,
          decoration: new InputDecoration(
            hintText: '${UIData.inputHintPassword}',
            labelText: '${UIData.inputLabelPassword}',
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                semanticLabel: _obscureText ? 'show password' : 'hide password',
              ),
            ),
          ),
          obscureText: _obscureText,
          validator: UIData.validatePassword,
          onSaved: (String val) {
            password = val;
          }),
    );
  }

  _showForgotPasswordButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, UIData.forgotPasswordRoute);
        },
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(right: 27.0),
                child: FlatButton(
                  child: new Text('${UIData.labelForgotPassword}',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold)), onPressed: () {},
                ))
          ],
        ),
      )
    ]);
  }

  _showFormIcon(bool changeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 30.0,
          backgroundColor: changeColor ? Colors.white.withOpacity(0.2) : Colors
              .grey.withOpacity(0.2),
          child: Icon(Icons.person, color: Colors.black),
        ),
      ],
    );
  }

  /*_clearData() {
    _mobileController.text = "";
    _passwordController.text = "";
  }*/

  _showLoginPressIcon() {
    return Container(
        height: 430,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: StreamBuilder<FetchProcess>(
            stream: loginBloc.apiResult,
            builder: (context, snapshot) {
              return CustomFloatForm(
                icon:Icons.navigate_next,
                isMini: false,
                qrCallback: ()  {
                  _sendToServer();
                },
              );
            },
          ),
        ));
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();

      loginBloc.loginSink.add(BikerViewModel.login(
          phoneNumber: mobile.replaceAll(" ", ""),
          password: password));
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  signUp() =>
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('${UIData.labelDoNotAccount}',
                style: TextStyle(color: Colors.grey)),
            new FlatButton(
              child: new Text('${UIData.labelSignUp}',
                  style: TextStyle(
                      color: Colors.orange,
                      //decoration: TextDecoration.underline,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pushNamed(context, UIData.signUpRoute);
              },
            ),
          ],
        ),
      );

  Future loginSp(int id, String username, String mobile) async {
    DateTime nowDateTime = DateTime.now();
    String patternDateTime = DateFormat('yyyy-MM-dd kk:mm a').format(
        nowDateTime);

    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('profile', "");

    sharedPreferences.setString('mobile', mobile);
    sharedPreferences.setString('userName', username);
    sharedPreferences.setInt('id', id);
    sharedPreferences.setString('loginTime', patternDateTime);

    /*Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => new TabDelivery()),
    );*/
  }
}
