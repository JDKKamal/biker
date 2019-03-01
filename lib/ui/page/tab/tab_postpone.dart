import 'dart:async';
import 'package:biker/logic/bloc/postpone_bloc.dart';
import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/model/postpone/postpone_response.dart';
import 'package:biker/services/network/api_subscription.dart';
import 'package:biker/ui/page/tab/delivery_row.dart';
import 'package:biker/utils/uidata.dart';
import 'package:flutter/material.dart';

class TabPostPonePage extends StatefulWidget {
  @override
  _TabPostPonePageState createState() => _TabPostPonePageState();
}

class _TabPostPonePageState extends State<TabPostPonePage>
{

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  PostPoneBloc postPoneBloc;

  @override
  void initState() {
    super.initState();

    postPoneBloc = new PostPoneBloc();
    apiSubscription(postPoneBloc.postPoneResult, context);

    postPoneBloc.postPoneSink.add(BikerViewModel.delivery());
  }

  Future<Null> _onRefresh() async {
    new Timer(new Duration(seconds: 3), () {
      setState(() {

      });
    });
  }

  bodyData() {
    return StreamBuilder<FetchProcess>(
        stream: postPoneBloc.postPoneResult,
        builder: (context, snapshot) {
          return snapshot.hasData
              ?  snapshot.data.statusCode == UIData.resCode200 ?  _bodyList(snapshot.data.networkServiceResponse.response) : Container()
              :  Container();
        });
  }

  Widget _bodyList(List<PostPoneResponse> postPone) {
      return new Stack(children: <Widget>[
        RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefresh,
          child: ListView.builder(
              itemCount: postPone.length,
              itemBuilder: (context, position) {
                return new Card(
                  color: Theme.of(context).cardColor,
                  //RoundedRectangleBorder, BeveledRectangleBorder, StadiumBorder
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0), top: Radius.circular(2.0)),
                  ),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DeliveryRow(
                          postPone[position].refNo.toString(),
                          postPone[position].codAmount.toString(),
                          postPone[position].endCustomer,
                          postPone[position].brand,
                          postPone[position].contactNo,
                          postPone[position].fullAddress,
                          postPone[position].model,
                          postPone[position].assignTime,
                          postPone[position].postponedReason,
                          postPone[position].description),
                    ],
                  ),
                );
              }),
        ),
      ]);
  }

  @override
  void dispose() {
    if (this.mounted) super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: bodyData());
  }
}
