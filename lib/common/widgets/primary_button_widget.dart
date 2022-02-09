import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  const PrimaryButtonWidget({
    Key? key,
    required this.onPressed,
    required this.child,
    this.color = COLOR_PURPLE,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
