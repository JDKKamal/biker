import 'package:biker/logic/bloc/drawer_bloc.dart';
import 'package:biker/model/drawer/drawer_response.dart';
import 'package:flutter/material.dart';
import 'package:biker/ui/widgets/profile_tile.dart';
import 'package:biker/utils/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonDrawer extends StatefulWidget {
  @override
  CommonDrawerState createState() {
    return new CommonDrawerState();
  }
}

class CommonDrawerState extends State<CommonDrawer> {
  DrawerBloc drawerBloc;

  @override
  void initState() {
    super.initState();
    drawerBloc = new DrawerBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        ClipPath(
          clipper: CustomDrawerClipper(),
          child: Material(
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      StreamBuilder<DrawerResponse>(
                          stream: drawerBloc.user,
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ?   UserAccountsDrawerHeader(
                              accountName: Row(children: <Widget>[
                                Icon(
                                  Icons.account_circle,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                Text(snapshot.data.empName,
                                    style: new TextStyle(fontSize: 18.0, color: Colors.white))
                              ]),
                              accountEmail: Row(children: <Widget>[
                                Icon(Icons.phone_android, color: Colors.white70, size: 20),
                                Text(snapshot.data.empMobile,
                                    style: new TextStyle(fontSize: 14.0, color: Colors.white))
                              ]),
                              currentAccountPicture: snapshot.data.photo == null
                                  ? new CircleAvatar(
                                  backgroundImage:
                                  new ExactAssetImage(UIData.imageProfile))
                                  :new CircleAvatar(
                                backgroundImage: new FileImage(snapshot.data.photo),
                                radius: 65.0,
                              ),
                            )
                                : Center(child: CircularProgressIndicator());
                          }),
                      CustomListView(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          name: "Home",
                          leading: Icon(Icons.home, color: Colors.blue)),
                      CustomListView(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, UIData.profileRoute);
                          },
                          name: "Profile",
                          leading: Icon(Icons.person, color: Colors.green)),
                      CustomListView(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, UIData.dashBoardRoute);
                          },
                          name: "Dashboard",
                          leading: Icon(Icons.dashboard, color: Colors.brown)),
                      CustomListView(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, UIData.contactRoute);
                          },
                          name: "Contact Us",
                          leading: Icon(Icons.contacts, color: Colors.cyan)),
                      Divider(),
                      CustomListView(
                          onPressed: () {
                            Navigator.pop(context);
                            logoutSP(context);
                          },
                          name: "Logout",
                          leading: Icon(Icons.vpn_key, color: Colors.red)),
                      Divider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        FractionalTranslation(
          translation: Offset(-0.24, 0.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Material(
                elevation: 9.0,
                type: MaterialType.circle,
                color: Colors.transparent,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  goToLogoutDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    successLogout(),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FloatingActionButton(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.clear,
                              color: Colors.black,
                              size: 30.0,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ]),
                  ],
                ),
              ),
            ));
  }

  successLogout() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ProfileTile(
                  title: "Logout",
                  textColor: Colors.black,
                  subtitle: "Are you sure want to logout?",
                ),
                ListTile(
                  title: Text('Username',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.normal)),
                  subtitle: Text("Login date time : ",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.normal)),
                  trailing: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                        "https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg"),
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                    width: double.infinity,
                    child: RaisedButton(
                        elevation: 0.0,
                        splashColor: Colors.redAccent,
                        padding: EdgeInsets.all(12.0),
                        shape: StadiumBorder(),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontFamily: 'Raleway'),
                        ),
                        color: Colors.red,
                        onPressed: () {
                          logoutSP(context);
                        })),
              ],
            ),
          ),
        ),
      );
}

logoutSP(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("mobile", "");
  sharedPreferences.setString('userName', "");
  sharedPreferences.setInt('id', 0);
  sharedPreferences.setString('loginTime', "");
  sharedPreferences.clear();

  Navigator.of(context).pushNamedAndRemoveUntil(
      UIData.loginRoute, (Route<dynamic> route) => false);
}

class CustomDrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height / 2 - 30);

    print(size.width);
    path.arcToPoint(
      Offset(size.width, size.height / 2 + 30),
      radius: Radius.circular(30.0),
      clockwise: false,
    );

    path.lineTo(size.width, size.height / 2 + 10.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CustomListView extends StatelessWidget {
  CustomListView(
      {@required this.onPressed, @required this.name, @required this.leading});

  final GestureTapCallback onPressed;
  final String name;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
        ),
        leading: leading,
        onTap: onPressed);
  }
}
