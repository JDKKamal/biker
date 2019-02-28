import 'package:biker/ui/page/tab/tab_dispatch.dart';
import 'package:biker/ui/page/tab/tab_pick_up.dart';
import 'package:biker/ui/page/tab/tab_postpone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biker/ui/widgets/common_scaffold.dart';
import 'package:biker/utils/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabDelivery extends StatefulWidget {
  @override
  _TabDeliveryState createState() => new _TabDeliveryState();
}

class _TabDeliveryState extends State<TabDelivery> with SingleTickerProviderStateMixin {
  SharedPreferences sharedPreferences;
  TabController tabController;
  String mobile, userName, loginDateTime;
  TextStyle tabStyle = TextStyle(fontSize: 15);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    getCredential();
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      mobile = sharedPreferences.getString("mobile");
      userName = sharedPreferences.getString("userName");
      loginDateTime = sharedPreferences.getString("loginTime");
    });
  }

  tabCreate() =>
      CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: Scaffold(
              backgroundColor: Colors.orangeAccent,
              appBar: TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                controller: tabController,
                isScrollable: false,
                tabs: <Widget>[
                  //TODO TAB NAME PICKUP, DISPATCH, POSTPONE
                  tabName('${UIData.tabPickUp}'),
                  tabName('${UIData.tabDispatch}'),
                  tabName('${UIData.tabPostpone}'),
                ],
              ),
              body: TabBarView(
                controller: tabController,
                children: <Widget>[
                  //TODO TAB SLIDING
                  new TabPickUpPage(),
                  new TabDispatchPage(),
                  new TabPostPonePage(),
                ],
              ),
            ),
          ),
        ],
      );

  _scaffold() =>
      CommonScaffold(
          appTitle: UIData.appName,
          bodyData: tabCreate(),
          showDrawer: true,
          centerDocked: true,
          showFAB: true,
          floatingIcon: Icons.phone_android,
          showBottomNav: true);

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  tabName(String name) => Tab(
    child: Text(
      name,
      style: tabStyle,
    ),
  );
}
