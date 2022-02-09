import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';

class OutlineButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  const OutlineButtonWidget({
    Key? key,
    required this.onPressed,
    required this.child,
    this.color = COLOR_PURPLE,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          primary: color,
          minimumSize: Size(double.infinity, 50),
          side: BorderSide(color: COLOR_PINK),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
