

import 'package:intl/intl.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/widgets/error_dialog_modal.dart';
import 'package:rte_app/models/cookie.dart';
import 'package:flutter/material.dart';

class AppUtil {
  static AppUtil _instance = AppUtil._internal();

  AppUtil._internal();

  factory AppUtil() {
    return _instance;
  }

  Cookie parseCookie(String cookie) {
    var c = cookie.split(';');
    Cookie parseCookie = Cookie()
      ..session = c[0]
      ..expirationDate = c[1]
      ..age = c[2];

    return parseCookie;
  }

  String convertDateTimeToString(DateTime dt) => '${dt.year}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}';

  String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime notificationDate = DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  void modalHudLoad(context,
      {String load = "Loading...",
        Color color = Colors.white,
        Color indicatorColor = Colors.white}) async {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.4),
      barrierDismissible: false,
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: COLOR_PURPLE),
            SizedBox(height: 10),
            Text(
              load,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  void confirmModal(context,
      {String title = "Continue Reading",
        Function? back,
        String message = "Something went wrong\nPlease try again later.",
        Function? onPressed,
        bool cancelBtn = false ,
        String confirmText = "Yes",
        bool barrierDismissible = true,
      }) async {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline6!.copyWith(
            color: COLOR_PURPLE,
          ),
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(),
        ),
        actions: [
          if(cancelBtn) ...[
            TextButton(
                style: TextButton.styleFrom(primary: Colors.black54),
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel')
            ),
          ],
          TextButton(
              style: TextButton.styleFrom(primary: COLOR_PINK),
              onPressed: () {
                if(onPressed == null) {
                  Navigator.pop(context);
                } else {
                  onPressed();
                }
              },
              child: Text(confirmText),
          ),
        ],
      )
    );
  }

  void errorModal(context,
      {String title = "Ooopps",
        Function? back,
        String message = "Something went wrong\nPlease try again later."}) async {
    showDialog(
      context: context,
      builder: (_) => ErrorDialogModal(
        title: title,
        message: message,
        onOk: () {
          Navigator.pop(context);
        },
      ),
    );
  }

}

