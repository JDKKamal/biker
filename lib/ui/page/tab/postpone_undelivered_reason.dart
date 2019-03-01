import 'package:biker/logic/bloc/reason_undelivered_bloc.dart';
import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/model/reason/reason.dart';
import 'package:biker/services/network/api_subscription.dart';
import 'package:biker/ui/widgets/common_dialogs.dart';
import 'package:biker/ui/widgets/common_scaffold.dart';
import 'package:biker/ui/widgets/custom_float_form.dart';
import 'package:biker/utils/uidata.dart';
import 'package:flutter/material.dart';

class PostPoneUndeliveredReasonPage extends StatefulWidget {
  final title, reasonName, id;
  final position;

  PostPoneUndeliveredReasonPage({this.title, this.reasonName, this.id, this.position});

  createState() {
    return new _PostPoneUndeliveredReasonState(title, reasonName, id, position);
  }
}

class _PostPoneUndeliveredReasonState extends State<PostPoneUndeliveredReasonPage>
{
  String reasonDescription;
  ReasonUndeliveredBloc reasonUndeliveredBloc;

  _PostPoneUndeliveredReasonState(String title, String reasonName, String id, int position);

  @override
  void initState() {
    super.initState();

    reasonUndeliveredBloc = new ReasonUndeliveredBloc();
    apiSubscription(reasonUndeliveredBloc.undeliveredReasonListResult, context);
    apiSubscription(reasonUndeliveredBloc.undeliveredReasonBehaviorSubject, context);

    reasonUndeliveredBloc.undeliveredReasonListSink.add(BikerViewModel.delivery());
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  bodyData() {
    return StreamBuilder<FetchProcess>(
        stream: reasonUndeliveredBloc.undeliveredReasonListResult,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? snapshot.data.statusCode == UIData.resCode200 ? bodyList(snapshot.data.networkServiceResponse.response) : Container()
              : Center(child: CircularProgressIndicator());
        });
  }

  bodyList(List<ReasonResponse> undeliveredReasonList) => Column(
        children: <Widget>[
          titleHeader(),
          //dateTimePicker(),
          new Expanded(
            child: new ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: undeliveredReasonList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                  splashColor: Colors.black12,
                  onTap: () {
                    setState(() {
                      undeliveredReasonList
                          .forEach((element) => element.isSelected = false);
                      undeliveredReasonList[index].isSelected = true;
                      reasonDescription = undeliveredReasonList[index].reasonName;
                    });
                  },
                  child: new ReasonItem(undeliveredReasonList[index]),
                );
              },
            ),
          ),
          Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: StreamBuilder<FetchProcess>(
                  stream: reasonUndeliveredBloc.undeliveredReasonListResult,
                  builder: (context, snapshot) {
                    return CustomFloatForm(
                      icon: Icons.done,
                      isMini: true,
                      qrCallback: () {
                        if (reasonDescription != null) {
                          reasonUndeliveredBloc.undeliveredReasonBehaviorSubjectSink.add(
                              BikerViewModel.deliveryOption(
                                  title: widget.title,
                                  reasonName: widget.reasonName,
                                  selectReason: reasonDescription,
                                  inquiryNo: widget.id));
                        }
                        else {
                          toast('${UIData.labelSelect1Reason}');
                        }
                      },
                    );
                  },
                ),
              )),
        ],
      );

  titleHeader() => Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Text(
            widget.reasonName,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black54,
                fontSize: 22.0),
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      );

  Widget _scaffold() =>
      CommonScaffold(appTitle: widget.title, bodyData: bodyData());
}

class ReasonItem extends StatelessWidget {
  final ReasonResponse reasonResponse;

  ReasonItem(this.reasonResponse);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(10.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            child:  Icon( reasonResponse.isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
             color: reasonResponse.isSelected ? Colors.orange : Colors.black),
          ),

         /* new Container(
            height: 25.0,
            width: 34.0,
            child: new Center(
              child: new Text(reasonResponse.id.toString(),
                  style: new TextStyle(
                      color: reasonResponse.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 12.0)),
            ),
            decoration: new BoxDecoration(
              color: reasonResponse.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: reasonResponse.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),*/

          new Container(
            margin: new EdgeInsets.only(left: 10.0),
            child: new Text(reasonResponse.reasonName,
                style: new TextStyle(
                  fontSize: 13,
                  color: reasonResponse.isSelected ? Colors.orange : Colors.black,
                )),
          )
        ],
      ),
    );
  }
}
