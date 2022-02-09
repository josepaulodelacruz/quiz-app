import 'package:flutter/material.dart';
import 'package:rte_app/blocs/counter_bloc.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/widgets/primary_button_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SizedBox(
        width: SizeConfig.screenWidth!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            SizedBox(
              width: SizeConfig.screenWidth! * .60,
              height: SizeConfig.screenHeight! * .30,
              child: Placeholder(),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: PrimaryButtonWidget(
                onPressed: () {
                  Navigator.pushNamed(context, login_screen);
                },
                child: Text(
                  'LOGIN',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
