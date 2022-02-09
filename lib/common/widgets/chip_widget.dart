import 'package:flutter/material.dart';
import 'package:rte_app/common/size_config.dart';

class ChipWidget extends StatelessWidget {
  String title;
  String? icon;

  ChipWidget({
    Key? key,
    required this.title,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 2
      ),
      onPressed: () {},
      icon: Icon(Icons.home, color: Colors.black),
      label: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: SizeConfig.blockSizeVertical! * 2.3
        )
      ),

    );
  }
}
