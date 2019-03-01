import 'package:flutter/material.dart';
import 'package:biker/utils/uidata.dart';
import 'package:strings/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryRow extends StatelessWidget {
  final String inquiryNo;
  final String amount;
  final String name;
  final String brand;
  final String mobile;
  final String address;
  final String model;
  final String dateTime;
  final String reason;
  final String deliveryType;

  DeliveryRow(this.inquiryNo, this.amount, this.name, this.brand, this.mobile, this.address, this.model, this.dateTime, this.reason, this.deliveryType);

  @override
  Widget build(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(
              left: 5, right: 5, top: 5),
          child: nameCallMap(name, mobile, address),
        ),
        new Expanded(
          child: new Padding(
            padding: EdgeInsets.all(5.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      expandStyle(3, widgetInquiryNo(inquiryNo)),
                      expandStyle(2, widgetRs(amount)),
                      expandStyle(2, widgetDateTime(dateTime)),
                    ]),
                widgetName(name),
                widgetModel(brand, model),
                widgetMobile(mobile),
                widgetAddress(address),
                widgetReason(reason),
                widgetDeliveryType(deliveryType)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
_openMap(String pinCode) async {
  String url = 'https://www.google.com/maps/search/?api=1&query=$pinCode';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
//TODO PICK UP DETAIL WIDGETS
nameCallMap(String name, String mobile, String address) =>Column(
  children: [
    GestureDetector(
      onTap: () {},
      child: CircleAvatar(
        radius: 21.0,
        child: new Text(
          name.substring(0, 1),
          style: new TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: UIData.colorRoundText),
        ),
        backgroundColor: UIData.colorRoundTextBg,
      ),
    ),
    GestureDetector(
      onTap: () {
        launch("tel:" + mobile
            .replaceAll(" ", ""));
      },
      child: CircleAvatar(
        radius: 21.0,
        child: new Icon(Icons.phone,
            color: UIData.colorIconCall),
        backgroundColor: Colors.transparent,
      ),
    ),
    GestureDetector(
        onTap: () {
          String pinCode =
          reverse(address)
              .split(" ")[0];
          _openMap(reverse(pinCode));
        },
        child: CircleAvatar(
          radius: 21.0,
          child: new Icon(Icons.map,
              color: UIData.colorIconMap),
          backgroundColor: Colors.transparent,
        )),
  ],
);

widgetInquiryNo(String inquiryNo) =>
    new Column(
        children: [
          new Text(
            inquiryNo
                .contains(".")
                ? inquiryNo
                .split(".")[0]
                : inquiryNo,
            style: new TextStyle(
                fontFamily: 'Raleway',
                fontSize: 15.0,
                color: UIData
                    .colorInquiryNo),
          ),
          new Container(
            color: UIData
                .colorInquiryNo,
            width: inquiryNo
                .length <=
                3
                ? 7.0 *
                inquiryNo
                    .length
                : 21.0,
            height: 1.5,
          ),
        ],
        crossAxisAlignment:
        CrossAxisAlignment.start);

widgetDateTime(String dateTime) =>
    new Text(
      dateTime.split(" ")[0] +
          "\n" +
          dateTime.split(" ")[1],
      textAlign: TextAlign.right,
      style: new TextStyle(
          fontSize: 11.0,
          color: UIData.colorDate),
    );

widgetRs(String amount) =>
    new Text(
      amount.isEmpty? "" : "Rs. " + amount,
      textAlign: TextAlign.right,
      style: new TextStyle(
          fontSize: 14.0,
          color: UIData.colorDate),
    );


widgetName(String name) =>
    new Container(
      margin: new EdgeInsetsDirectional.only(
          top: 10.0),
      child: Text(
        name,
        style: new TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 17.0,
            color: UIData.colorName,
            fontWeight: FontWeight.bold),
      ),
    );

widgetModel(String brand, String model) =>
    new Text(
      brand +
          " - " +
          model,
      style: new TextStyle(
          fontSize: 14.0,
          color: UIData.colorModel),
    );

widgetMobile(String mobile) =>
    new Text(
      "Mobile - " + mobile,
      style: new TextStyle(
          fontSize: 14.0,
          color: UIData.colorMobile),
    );

widgetAddress(String address) =>
    new Padding(
      padding: const EdgeInsets.only(
          top: 2.0),
      child: Text(
        address,
        style: new TextStyle(
            fontSize: 15.0,
            color: UIData.colorAddress),
      ),
    );

widgetReason(String reason) =>
 reason.isEmpty? Container() :
 new Padding(
   padding: const EdgeInsets.only(
       top: 2.0, bottom: 2.0),
   child: Text(
     reason,
     style: new TextStyle(
         fontSize: 13,
         color:  UIData.colorReason),
   ),
 );

widgetDeliveryType(String deliveryType) => deliveryType.isEmpty? Container() :
new Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: <Widget>[
    new MaterialButton(
      height: 27.0,
      minWidth: 1.0,
      textColor: Colors.orange,
      child: new Text(
          deliveryType,
          style: new TextStyle(fontSize: 12.0)),
      onPressed: () {},
    ),
  ],
);

//TODO PICKUP BUTTON WIDGETS
buttonTextStyle(String btnName) => new Text(btnName,
    style: new TextStyle(fontSize: 12.0));

expandStyle(int flex, Widget child) => Expanded(
    flex: flex,
    child: child);