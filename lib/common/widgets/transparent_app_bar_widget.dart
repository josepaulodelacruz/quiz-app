import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';

class TransparentAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final double? elevation;
  final Function? onPressed;
  final String? title;
  final bool centerTitle;
  final TextStyle? titleStyle;
  List<Widget> actions;
  Color? backgroundColor;
  TransparentAppBarWidget({
    Key? key,
    this.elevation = 0,
    this.onPressed,
    this.title = "",
    this.backgroundColor = Colors.transparent,
    this.centerTitle = false,
    this.actions = const [],
    this.titleStyle,
  }) : preferredSize = Size.fromHeight(54), super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: elevation,
      title: Text(title!, style: titleStyle),
      iconTheme: IconThemeData(
        color: COLOR_PURPLE,
      ),
      leading: IconButton(
        onPressed: () {
          if(onPressed == null) {
            Navigator.pop(context);
          } else {
            onPressed!();
          }
        },
        icon: Icon(Icons.arrow_back)
      ),
      actions: actions,
    );
  }
}
