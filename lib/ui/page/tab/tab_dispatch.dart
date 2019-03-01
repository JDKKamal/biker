import 'dart:async';
import 'package:biker/logic/bloc/dispatch_bloc.dart';
import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:biker/model/dispatch/dispatch_response.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/services/network/api_subscription.dart';
import 'package:biker/ui/page/tab/delivery_row.dart';
import 'package:biker/ui/page/tab/postpone_cancel_reason.dart';
import 'package:biker/ui/page/tab/postpone_undelivered_reason.dart';
import 'package:biker/ui/widgets/profile_tile.dart';
import 'package:biker/utils/uidata.dart';
import 'package:flutter/material.dart';

class TabDispatchPage extends StatefulWidget {
  @override
  _TabDispatchPageState createState() => _TabDispatchPageState();
}

class _TabDispatchPageState extends State<TabDispatchPage> {
  String position;
  DispatchBloc dispatchBloc;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    dispatchBloc = new DispatchBloc();
    apiSubscription(dispatchBloc.dispatchListResult, context);
    apiSubscription(dispatchBloc.dispatchDoneResult, context);

    dispatchBloc.dispatchListSink.add(BikerViewModel.delivery());
  }

  Future<void> _onRefresh() async {
    new Timer(new Duration(seconds: 3), () {

    });
  }

  @override
  void dispose() {
    if (this.mounted) super.dispose();
  }

  bodyData() {
    return StreamBuilder<FetchProcess>(
        stream: dispatchBloc.dispatchListResult,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? snapshot.data.statusCode == UIData.resCode200 ?  _bodyList(snapshot.data.networkServiceResponse.response) : Container()
              : Container();
        });
  }

  Widget _bodyList(List<DispatchResponse> dispatchList) {
      return new Stack(children: <Widget>[
        RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefresh,
          child: ListView.builder(
              itemCount: dispatchList.length,
              itemBuilder: (context, position) {
                return new Card(
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder //RoundedRectangleBorder, BeveledRectangleBorder, StadiumBorder select any oneL̥
                    (
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0), top: Radius.circular(2.0)),
                  ),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DeliveryRow(dispatchList[position].jobId.toString(),
                          dispatchList[position].codAmount.toString(),
                          dispatchList[position].name,
                          dispatchList[position].brand,
                          dispatchList[position].mobile,
                          dispatchList[position].address,
                          dispatchList[position].model,
                          dispatchList[position].dispatchDateTime,
                          "",
                          ""),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new MaterialButton(
                              height: 27.0,
                              minWidth: 1.0,
                              textColor: Colors.green,
                              child: new Text('${UIData.btnDone}',
                                  style: new TextStyle(fontSize: 12.0)),
                              onPressed: () {
                                goToDoneDispatch(dispatchList[position], position);
                              }
                              ),
                          new MaterialButton(
                              height: 27.0,
                              minWidth: 1.0,
                              textColor: Colors.brown,
                              child: new Text('${UIData.btnPostpone}',
                                  style: new TextStyle(fontSize: 12.0)),
                              onPressed: () {
                                this.position = dispatchList[position].jobId;
                                _navigateAndDisplayPostPone(context,
                                    dispatchList[position], position);
                              }),
                          new MaterialButton(
                              height: 27.0,
                              minWidth: 1.0,
                              textColor: Colors.redAccent,
                              child: new Text('${UIData.btnUndelivered}',
                                  style: new TextStyle(fontSize: 12.0)),
                              onPressed: () async {
                                this.position = dispatchList[position].jobId;
                                _navigateAndDisplayUndelivered(dispatchList[position], position);
                              }),
                        ],
                      ),
                    ],
                  ),
                );
              }),
        )
      ]);
    }

  goToDoneDispatch(DispatchResponse dispatchResponse, int position) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          doneDispatch(dispatchResponse),
                          Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      child: StreamBuilder<FetchProcess>(
                                        stream: dispatchBloc.dispatchDoneResult,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {

                                          }
                                          else if (snapshot.hasError) {

                                          }
                                          return FloatingActionButton.extended(
                                            elevation: 4.0,
                                            backgroundColor: Colors.white,
                                            icon: Icon(
                                                dispatchResponse.lonerPhone == 0
                                                    ? Icons.block
                                                    : Icons.phone_android,
                                                color: dispatchResponse.lonerPhone == 0
                                                    ? Colors.red
                                                    : Colors.orangeAccent),
                                            label: Text(
                                              dispatchResponse.lonerPhone == 0
                                                  ? '${UIData.labelNoLoner}'
                                                  :  '${UIData.labelLoner}',
                                              style: new TextStyle(
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 15.0,
                                                  color: dispatchResponse.lonerPhone == 0
                                                      ? Colors.red
                                                      : Colors.orangeAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              dispatchBloc.dispatchDoneSink.add(
                                                  BikerViewModel.deliveryOption(
                                                      title: UIData.tabDispatch,
                                                      lonerPhone: dispatchResponse.lonerPhone==1?'1':'0',
                                                      reasonName: UIData.btnDone,
                                                      inquiryNo: dispatchResponse.jobId.toString()));
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ])
                        ],
                      ),
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
                                    ))
                              ])),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  doneDispatch(DispatchResponse dispatchResponse) => Container(
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
              title:  '${UIData.tabDispatch}',
              textColor: Colors.black,
              subtitle: '${UIData.msgDoneDispatch}',
            ),
            ListTile(
                title: Text('${UIData.labelName}',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.normal)),
                subtitle: Text(dispatchResponse.name,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.normal)))
          ],
        ),
      ),
    ),
  );

  _navigateAndDisplayPostPone(
      BuildContext context, DispatchResponse dispatchResponse, int position) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostPoneCancelReasonPage(
              title: '${UIData.tabDispatch}',
              reasonName: '${UIData.btnPostpone}',
              id: dispatchResponse.jobId.toString(),
              position: position)),
    );

    //RETURN DATA postpone_cancel_reason.dart
    if (result != null) {
      dispatchBloc.dispatchRemove(this.position);
      this.position = null;
    }
  }

  _navigateAndDisplayUndelivered(DispatchResponse dispatchResponse, int position) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostPoneUndeliveredReasonPage(
              title: '${UIData.tabDispatch}',
              reasonName: '${UIData.btnUndelivered}',
              id: dispatchResponse.jobId.toString(),
              position: position)),
    );

    //RETURN DATA postpone_cancel_reason.dart
    if (result != null) {
      dispatchBloc.dispatchRemove(this.position);
      this.position = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: bodyData());
  }
}
