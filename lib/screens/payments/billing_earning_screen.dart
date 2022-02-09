import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/widgets/primary_button_widget.dart';
import 'package:rte_app/common/widgets/transparent_app_bar_widget.dart';

class BillingEarningScreen extends StatelessWidget {
  const BillingEarningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: TransparentAppBarWidget(
        centerTitle: true,
        title: "Billing and Earnings",
        titleStyle: Theme.of(context).textTheme.headline6!.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 2.5,
        ),
      ),
      body: SizedBox(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _upperSection(context),
            _lowerSection(context),
          ],
        )
      ),
    );
  }

  Widget _upperSection(context)  {
    return Flexible(
      flex: 1,
      child: Column(
        children: [
          Placeholder(
            fallbackHeight: SizeConfig.screenHeight! * .20,
          ),
          SizedBox(height: 10),
          Text(
            "Link your accounts for easy access",
            style: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.w600,
            )
          ),
          SizedBox(height: 10),
          Text(
            "Connect your accuonts with GEM for\n easy cash out process",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: COLOR_DARK_GRAY,
              fontSize: SizeConfig.blockSizeVertical! * 2,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: PrimaryButtonWidget(
              color: COLOR_PINK,
              onPressed: () {
                Navigator.pushNamed(context, payments_method_screen);
              },
              child: Text(
                "Connect Account",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              )
            ),
          )
        ],
      )
    );
  }

  Widget _lowerSection (context) {
    return Flexible(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 8,
              width: 70,
              decoration: BoxDecoration(
                color: COLOR_DARK_GRAY,
                borderRadius: BorderRadius.circular(20)
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Time Spending",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Spacer(),
            Placeholder(
              fallbackHeight: SizeConfig.screenHeight! * .30,
            ),
          ],
        )
      ),
    );
  }
}
