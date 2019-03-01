import 'package:biker/logic/bloc/reason_postpone_cancel_bloc.dart';
import 'package:biker/logic/viewmodel/biker_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/model/reason/reason.dart';
import 'package:biker/services/network/api_subscription.dart';
import 'package:biker/ui/widgets/common_dialogs.dart';
import 'package:biker/ui/widgets/common_scaffold.dart';
import 'package:biker/ui/widgets/custom_float_form.dart';
import 'package:biker/utils/uidata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostPoneCancelReasonPage extends StatefulWidget {
  final title, reasonName, id;
  final position;

  PostPoneCancelReasonPage(
      {this.title, this.reasonName, this.id, this.position});

  createState() {
    return new _PostPoneReasonCancelPageState(title, reasonName, id, position);
  }
}

class _PostPoneReasonCancelPageState extends State<PostPoneCancelReasonPage> {
  String formattedDate, patternTime, time24Hour, reasonDescription;
  ReasonPostPoneCancelBloc reasonPostPoneCancelBloc;

  _PostPoneReasonCancelPageState(String title, String reasonName, String id,
      int position);

  @override
  void initState() {
    super.initState();

    var nowDate = new DateTime.now();
    var patternDate = new DateFormat('yyyy-MM-dd');
    formattedDate = patternDate.format(nowDate);

    DateTime nowTime = DateTime.now();
    patternTime = DateFormat('kk:mma').format(nowTime);

    int time12Add = int.parse(DateFormat('kk').format(nowTime));
    time24Hour = time12Add.toString() + ":" + DateFormat('mm').format(nowTime);

    reasonPostPoneCancelBloc = new ReasonPostPoneCancelBloc();
    apiSubscription(
        reasonPostPoneCancelBloc.reasonPostPoneCancelListResult, context);

    reasonPostPoneCancelBloc.reasonPostPoneCancelListSink.add(
        BikerViewModel.delivery());
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _datePicked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now().subtract(new Duration(days: 1)),
      lastDate: new DateTime.now().add(new Duration(days: 30)),
    );

    if (_datePicked != null) {
      setState(() {
        formattedDate = _datePicked.year.toString() +
            "-" +
            _datePicked.month.toString() +
            "-" +
            _datePicked.day.toString();
      });
    }
  }

  Future<Null> _selectTime() async {
    final TimeOfDay _timePicked = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay.now(),
    );
    if (_timePicked != null) {
      if (_timePicked.hour.toString() == "0" &&
          _timePicked.period
              .toString()
              .replaceAll("DayPeriod.", "")
              .toUpperCase() ==
              "AM") {
        setState(() {
          patternTime = "12:" +
              _timePicked.minute.toString() +
              _timePicked.period
                  .toString()
                  .replaceAll("DayPeriod.", "")
                  .toUpperCase();
        });

        time24Hour = "24" + ":" + _timePicked.minute.toString();
      } else {
        int time12Add = _timePicked.hour;

        setState(() {
          patternTime = _timePicked.hour.toString() +
              ":" +
              _timePicked.minute.toString() +
              _timePicked.period
                  .toString()
                  .replaceAll("DayPeriod.", "")
                  .toUpperCase();
        });
        time24Hour = time12Add.toString() + ":" + _timePicked.minute.toString();
      }
    }
  }

  bodyData() {
    return StreamBuilder<FetchProcess>(
        stream: reasonPostPoneCancelBloc.reasonPostPoneCancelListResult,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? snapshot.data.statusCode == UIData.resCode200 ? bodyList(
              snapshot.data.networkServiceResponse.response) : Container()
              : Center(child: CircularProgressIndicator());
        });
  }

  bodyList(List<ReasonResponse> reasonList) =>
      Column(
        children: <Widget>[
          titleHeader(),
          widget.reasonName == UIData.btnCancel? Container() : dateTimePicker(),
          new Expanded(
            child: new ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: reasonList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                  splashColor: Colors.black12,
                  onTap: () {
                    setState(() {
                      reasonList.forEach((element) =>
                      element.isSelected = false);
                      reasonList[index].isSelected = true;

                      reasonDescription = reasonList[index].reasonName;
                    });
                  },
                  child: new ReasonItem(reasonList[index]),
                );
              },
            ),
          ),
          Container(
              child: Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: StreamBuilder<FetchProcess>(
                      stream: reasonPostPoneCancelBloc
                          .postPoneCancelReasonResult,
                      builder: (context, snapshot) {
                        return CustomFloatForm(
                          icon: Icons.done,
                          isMini: true,
                          qrCallback: () {
                            if (reasonDescription != null) {
                              apiSubscription(reasonPostPoneCancelBloc.postPoneCancelReasonResult, context);
                              reasonPostPoneCancelBloc.postPoneCancelReasonSink.add(
                                  BikerViewModel.deliveryOption(
                                      title: widget.title,
                                      reasonName: widget.reasonName,
                                      selectReason: reasonDescription,
                                      inquiryNo: widget.id,
                                      selectDate: formattedDate,
                                      selectTime: time24Hour));
                            }
                            else {
                              toast('${UIData.labelSelect1Reason}');
                            }
                          },
                        );
                      },
                    ),
                  ))),
        ],
      );

  dateTimePicker() =>
      Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          if (widget.reasonName != "CANCEL") {
                            _selectDate(context);
                          }
                        },
                        child: Text(
                          '${UIData.labelSelectDate}',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0, color: Colors.grey),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        formattedDate,
                        style:
                        new TextStyle(fontSize: 12.0, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          if (widget.reasonName != "CANCEL") {
                            _selectTime();
                          }
                        },
                        child: Text(
                          '${UIData.labelSelectTime}',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0, color: Colors.grey),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        patternTime,
                        style:
                        new TextStyle(fontSize: 12.0, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding:
                          const EdgeInsets.only(top: 30.0, bottom: 0.0),
                          child: Text(
                            '${UIData.labelSelectReason}' + widget.reasonName.toLowerCase(),
                            style: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          color: Colors.grey,
                          width: 24.0,
                          height: 1.5,
                        ),
                      ],
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                      child: Text(
                        '${UIData.labelSelect1Reason}',
                        style:
                        new TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  titleHeader() =>
      Column(
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

          /*new Container(
            height: 25.0,
            width: 34.0,
            child: new Center(
              child: new Text(_item.id.toString(),
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 12.0)),
            ),
            decoration: new BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
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