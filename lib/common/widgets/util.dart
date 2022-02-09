import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';

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