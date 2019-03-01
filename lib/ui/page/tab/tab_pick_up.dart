import 'dart:async';
import 'dart:ui';
import 'package:biker/logic/bloc/pick_up_bloc.dart';
import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/model/pickup/pickup_response.dart';
import 'package:biker/services/network/api_subscription.dart';
import 'package:biker/ui/page/tab/delivery_row.dart';
import 'package:biker/ui/page/tab/postpone_cancel_reason.dart';
import 'package:biker/ui/widgets/common_dialogs.dart';
import 'package:biker/ui/widgets/profile_tile.dart';
import 'package:biker/utils/uidata.dart';
import 'package:flutter/material.dart';

class TabPickUpPage extends StatefulWidget {
  @override
  _TabPickUpPageState createState() => _TabPickUpPageState();
}

class _TabPickUpPageState extends State<TabPickUpPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  int position;
  PickUpBloc pickUpBloc;

  @override
  void initState() {
    super.initState();

    pickUpBloc = new PickUpBloc();
    apiSubscription(pickUpBloc.pickUpListResult, context);
    apiSubscription(pickUpBloc.pickUpDoneBehaviorSubject, context);

    pickUpBloc.pickUpListSink.add(BikerViewModel.delivery());
  }

  Future<void> _onRefresh() async {
    new Timer(new Duration(seconds: 3), () {
      pickUpBloc.pickUpListSink.add(BikerViewModel.delivery());
    });
  }

  bodyData() {
    return StreamBuilder<FetchProcess>(
        stream: pickUpBloc.pickUpListResult,
         builder: (context, snapshot) {
          return snapshot.hasData
              ? snapshot.data.statusCode == UIData.resCode200 ?  _bodyList(snapshot.data.networkServiceResponse.response) : Container()
              : Container();
         });
  }

  Widget _bodyList(List<PickUpResponse> pickUpList) {
    return new Stack(children: <Widget>[
      RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        child: ListView.builder(
            itemCount: pickUpList.length,
            itemBuilder: (context, position) {
              return new Card(
                color: Theme
                    .of(context)
                    .cardColor,
                //RoundedRectangleBorder, BeveledRectangleBorder, StadiumBorder
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10.0), top: Radius.circular(2.0)),
                ),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DeliveryRow(
                        pickUpList[position].inquiryNo.toString(),
                        "",
                        pickUpList[position].name,
                        pickUpList[position].brand,
                        pickUpList[position].mobile,
                        pickUpList[position].address,
                        pickUpList[position].model,
                        pickUpList[position].pickUpDateTime,
                        "",
                        ""),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new MaterialButton(
                            height: 27.0,
                            minWidth: 1.0,
                            textColor: Colors.green,
                            child: buttonTextStyle('${UIData.btnDone}'),
                            onPressed: () async {
                              goToDonePickUp(
                                  pickUpList[position], position);
                            }),
                        new MaterialButton(
                            height: 27.0,
                            minWidth: 1.0,
                            textColor: Colors.brown,
                            child: buttonTextStyle('${UIData.btnPostpone}'),
                            onPressed: () {
                              this.position = pickUpList[position].inquiryNo;
                              _navigateAndDisplayPostPoneCancel(
                                  '${UIData.tabPickUp}',
                                  '${UIData.btnPostpone}',
                                  pickUpList[position],
                                  position);
                            }),
                        new MaterialButton(
                            height: 27.0,
                            minWidth: 1.0,
                            textColor: Colors.red,
                            child: buttonTextStyle('${UIData.btnCancel}'),
                            onPressed: () {
                              this.position = pickUpList[position].inquiryNo;
                              _navigateAndDisplayPostPoneCancel(
                                  '${UIData.tabPickUp}',
                                  '${UIData.btnCancel}',
                                  pickUpList[position], position);
                            }),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: bodyData());
  }

  @override
  void dispose() {
    if (this.mounted) super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  goToDonePickUp(PickUpResponse pickUpMain, int position) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          doneDispatch(pickUpMain),
                          Container(
                              margin: EdgeInsets.only(
                                  left: 0, top: 0, right: 10, bottom: 0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    SizedBox(
                                        width: 30.0,
                                        height: 30.0,
                                        child: FloatingActionButton(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.black,
                                            size: 20.0,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                    )
                                  ]))
                        ],
                      ),
                    ),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                child: StreamBuilder<FetchProcess>(
                                  stream: pickUpBloc.pickUpDoneResult,
                                  builder: (context, snapshot) {
                                    return FloatingActionButton.extended(
                                      elevation: 4.0,
                                      backgroundColor: Colors.white,
                                      icon: const Icon(Icons.block, color: Colors.red),
                                      label: Text(
                                        '${UIData.labelNoLoner}',
                                        style: new TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 15.0,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        pickUpBloc.pickUpDoneSink.add(
                                            BikerViewModel.deliveryOption(
                                                title: UIData.tabPickUp,
                                                lonerPhone: '0',
                                                reasonName: UIData.btnDone,
                                                inquiryNo: pickUpMain.inquiryNo
                                                    .toString()));
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          Column(
                            children: <Widget>[
                              Container(
                                child: StreamBuilder<FetchProcess>(
                                  stream: pickUpBloc.pickUpDoneResult,
                                  builder: (context, snapshot) {
                                    return FloatingActionButton.extended(
                                      elevation: 4.0,
                                      backgroundColor: Colors.white,
                                      icon: const Icon(Icons.phone_android,
                                          color: Colors.green),
                                      label: Text(
                                        '${UIData.labelLoner}',
                                        style: new TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 15.0,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        pickUpBloc.pickUpDoneSink.add(
                                            BikerViewModel.deliveryOption(
                                                title: UIData.tabPickUp,
                                                lonerPhone: '1',
                                                reasonName: UIData.btnDone,
                                                inquiryNo: pickUpMain.inquiryNo
                                                    .toString()));
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ],
                ),
              ),
            ));
  }

  doneDispatch(PickUpResponse pickUp) =>
      Container(
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
                  title: '${UIData.tabPickUp}',
                  textColor: Colors.black,
                  subtitle: '${UIData.msgDonePickUp}',
                ),
                ListTile(
                    title: Text('${UIData.labelName}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black54,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.normal)),
                    subtitle: Text(pickUp.name,
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.orange,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.normal)))
              ],
            ),
          ),
        ),
      );

  _navigateAndDisplayPostPoneCancel(String title, String reason, PickUpResponse pickUpResponse, int position) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PostPoneCancelReasonPage(
                  title: title,
                  reasonName: reason,
                  id: pickUpResponse.inquiryNo.toString(),
                  position: position)),
    );

    if (result != null) {
      pickUpBloc.pickUpRemove(this.position);
      this.position = null;
    }
  }

  frostedRound(Widget child) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: child));
  }

  frostedIconButton(Widget child) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle),
                child: child)));
  }

//TODO PICKUP BUTTON WIDGETS
  buttonTextStyle(String btnName) =>
      new Text(btnName,
          style: new TextStyle(fontSize: 12.0));

  expandStyle(int flex, Widget child) =>
      Expanded(
          flex: flex,
          child: child);
}
