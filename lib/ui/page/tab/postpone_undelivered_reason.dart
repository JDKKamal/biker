import 'package:biker/logic/bloc/reason_undelivered_bloc.dart';
import 'package:biker/logic/viewmodel/user_login_view_model.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/model/reason/reason.dart';
import 'package:biker/services/network/api_subscription.dart';
import 'package:biker/ui/widgets/common_scaffold.dart';
import 'package:biker/utils/uidata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String formattedDate, patternTime, time24Hour, reasonDescription;
  ReasonUndeliveredBloc reasonUndeliveredBloc;

  _PostPoneUndeliveredReasonState(String title, String reasonName, String id, int position);

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

    reasonUndeliveredBloc = new ReasonUndeliveredBloc();
    apiSubscription(reasonUndeliveredBloc.reasonUndeliveredResult, context);

    reasonUndeliveredBloc.reasonUndeliveredSink.add(UserLoginViewModel.pickUp(userId: "1"));
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  bodyData() {
    return StreamBuilder<FetchProcess>(
        stream: reasonUndeliveredBloc.reasonUndeliveredResult,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? snapshot.data.statusCode == 200 ? bodyList(snapshot.data.response.content) : Container()
              : Center(child: CircularProgressIndicator());
        });
  }

  bodyList(List<ReasonResponse> reasonUndeliveredList) => Column(
        children: <Widget>[
          titleHeader(),
          dateTimePicker(),
          new Expanded(
            child: new ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: reasonUndeliveredList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                  splashColor: Colors.black12,
                  onTap: () {
                    setState(() {
                      reasonUndeliveredList
                          .forEach((element) => element.isSelected = false);
                      reasonUndeliveredList[index].isSelected = true;
                      reasonDescription = reasonUndeliveredList[index].reasonName;
                    });
                  },
                  child: new ReasonItem(reasonUndeliveredList[index]),
                );
              },
            ),
          ),
          Container(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton.icon(
                icon: const Icon(
                  Icons.check_circle,
                  size: 28.0,
                  color: Colors.orangeAccent,
                ),
                label: const Text('${UIData.btnSubmit}',
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.orangeAccent,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold)),
                onPressed: () async {

                }),
          )),
        ],
      );

  dateTimePicker() => Column(
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
                      child: Text(
                        '${UIData.labelSelectDate}',
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.orange),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        formattedDate,
                        style:
                            new TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        '${UIData.labelSelectTime}',
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.orange),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        patternTime,
                        style:
                            new TextStyle(fontSize: 12.0, color: Colors.grey),
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
                              const EdgeInsets.only(top: 10.0, bottom: 0.0),
                          child: Text(
                            '${UIData.labelSelectReason}',
                            style: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          color: Colors.orange,
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

  titleHeader() => Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Text(
            'widget.reasonName',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 22.0),
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      );

  Widget _scaffold() =>
      CommonScaffold(appTitle: 'widget.title', bodyData: bodyData());
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
            //margin: new EdgeInsets.only(left: 10.0),
            child: new Text(reasonResponse.reasonName,
                style: new TextStyle(
                  fontSize: 13,
                  color: reasonResponse.isSelected ? Colors.black : Colors.grey,
                )),
          )
        ],
      ),
    );
  }
}
