import 'dart:async';

import 'package:flutter/material.dart';
import 'package:biker/model/fetch_process.dart';
import 'package:biker/ui/page/tab/tab_delivery.dart';
import 'package:biker/ui/widgets/common_dialogs.dart';
import 'package:biker/utils/uidata.dart';

apiSubscription(Stream<FetchProcess> apiResult, BuildContext context) {
  apiResult.listen((FetchProcess fetchProcess) {
    if (fetchProcess.loading) {
      showProgress(context);
    } else {
      hideProgress(context);
      if (fetchProcess.response.responseCode == 0) {
        fetchApiResult(context, fetchProcess.response); //Dialog network issue. For example - URL
      } else {
        switch (fetchProcess.type) {
          case ApiType.performLogin:
            if (fetchProcess.statusCode == 200) {
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

          case ApiType.performReasonUndelivered:
            break;

          case ApiType.performReasonPostPoneCancel:
            break;
        }
      }
    }
  });
}