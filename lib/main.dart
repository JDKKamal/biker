import 'package:biker/ui/page/contact/contact_page.dart';
import 'package:biker/ui/page/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:biker/di/dependency_injection.dart';
import 'package:biker/ui/page/forgotpassword/forgot_password_page.dart';
import 'package:biker/ui/page/login/login_page.dart';
import 'package:biker/ui/page/signup/signup_page.dart';
import 'package:biker/ui/page/splashscreen/splash_screen_page.dart';
import 'package:biker/ui/page/tab/tab_delivery.dart';
import 'package:biker/utils/translations.dart';
import 'package:biker/utils/uidata.dart';

void main() {
  Injector.configure(Flavor.Testing);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final materialApp = MaterialApp(
      title: UIData.appName,
    theme: ThemeData(
      //buttonColor: Colors.white,
        brightness: Brightness.light,
        accentColor: Colors.orange,
        primaryColor: Colors.orangeAccent,
        primarySwatch: Colors.orange,
        fontFamily: UIData.quickFont),
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      initialRoute: '/',
      localizationsDelegates: [
        const TranslationsDelegate(),
        //GlobalMaterialLocalizations.delegate,
        //GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en", "US"),
        const Locale("hi", "IN"),
      ],

      //routes
      routes: <String, WidgetBuilder>{
        '/': (context) => SplashScreenPage(),
        UIData.SplashScreenRoute: (BuildContext context) => SplashScreenPage(),
        UIData.loginRoute: (BuildContext context) => LoginPage(),
        UIData.signUpRoute: (BuildContext context) => SignUpPage(),
        UIData.forgotPasswordRoute: (BuildContext context) => ForgotPasswordPage(),
        UIData.tabRoute: (BuildContext context) => TabDelivery(),
        /*UIData.dashBoardRoute: (BuildContext context) => DashBoardPage(),*/
        UIData.profileRoute: (BuildContext context) => ProfilePage(),
        UIData.contactRoute: (BuildContext context) => ContactPage(),
      },
  );

  @override
  Widget build(BuildContext context) {
    return materialApp;
  }
}