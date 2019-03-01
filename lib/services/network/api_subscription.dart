import 'dart:async';

import 'package:biker/logic/bloc/pick_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/ui/page/tab/tab_delivery.dart';
import 'package:biker/ui/widgets/common_dialogs.dart';
import 'package:biker/utils/uidata.dart';

apiSubscription(Stream<FetchProcess> apiResult, BuildContext context) {

  apiResult.listen((FetchProcess fetchProcess) {
    //TODO LOADING OR PROGRESS BAR DIALOG
    if (fetchProcess.loadingStatus >= 1 && fetchProcess.loadingStatus != null) {
      fetchProcess.loadingStatus == 1 ? showProgress(context):  hideProgress(context);
    }

    if (fetchProcess.statusCode == 0) {
      fetchApiResult(context,
          fetchProcess.networkServiceResponse); //TODO DIALOG NETWORK ISSUE. FOR EXAMPLE - URL
    } else {
      switch (fetchProcess.type) {
        case ApiType.performLogin:
          if (fetchProcess.statusCode == UIData.resCode200) {
            toast(UIData.msgLoginSuccessfully);
            Navigator.pushReplacement(
              context,
              new MaterialPageRoute(builder: (context) => new TabDelivery()),
            );
          }
          else {
            toast(UIData.msgLoginError);
          }
          break;

        case ApiType.performPickUp:
          break;

        case ApiType.performDispatch:
          break;

        case ApiType.performPostPone:
          break;

        case ApiType.performUndeliveredReasonList:
          break;

        case ApiType.performPostPoneCancelReasonList:
          break;

        case ApiType.performPostPoneCancelReason:
          Navigator.pop(context, 0);
          break;
      }
    }
  });
}