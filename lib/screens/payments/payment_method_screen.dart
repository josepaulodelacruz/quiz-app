import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/utils.dart';
import 'package:rte_app/common/widgets/transparent_app_bar_widget.dart';

class PaymentMethodScreen extends StatelessWidget {
  final AppUtil _appUtil = AppUtil();
  PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: TransparentAppBarWidget(
        centerTitle: true,
        title: "Payment Method",
        titleStyle: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
            ),
      ),
      body: SizedBox(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: Column(
          children: [
            _cardHeader(context),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Text(
                      "Transaction History",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    _transactionTile(context),
                    _transactionTile(context),
                    _transactionTile(context),
                    _transactionTile(context),
                    _transactionTile(context),
                    _transactionTile(context),
                    _transactionTile(context),

                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _cardHeader(context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(10),
      height: 135,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: COLOR_PURPLE,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.menu, color: Colors.white),
          Text(
            "Account Balance",
            style: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.white
            ),
          ),
          SizedBox(height: 5),
          Text(
            "PHP 25,000",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: Colors.white,
              fontSize: SizeConfig.blockSizeVertical! * 1.6,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: COLOR_PINK,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                minimumSize: Size(0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                )
              ),
              onPressed: () {},
              child: Text(
                "Get Paid Now",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.white,
                  fontSize: SizeConfig.blockSizeVertical! * 1.6,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _transactionTile (context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        "SWIPE1225391",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
      ),
      subtitle: Text(
        "PHP: 29.64 on Dec 25, 2021 to Swipe",
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: SizeConfig.blockSizeVertical! * 1.6,
        ),
      ),
      trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              minimumSize: Size(0,30),
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: COLOR_PURPLE),
                borderRadius: BorderRadius.circular(2),
              )
          ),
          onPressed: () {
            _viewPaymentDialog(context);
          },
          child: Text(
            "View Payments",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontSize: SizeConfig.blockSizeVertical! * 1.6,
              color: COLOR_PURPLE,
            ),
          )
      ),
    );
  }

  void _viewPaymentDialog (context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "SWIPE1225391",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ammount: PHP 29.39",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: COLOR_DARK_GRAY,
              )
            ),
            Text(
                "Date and Time: 12/25/2021 | 11:30PM",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: COLOR_DARK_GRAY,
                )
            ),
            Text(
                "Account Number: (+63) 9982634391",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: COLOR_DARK_GRAY,
                )
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Colors.transparent,
              minimumSize: Size(SizeConfig.screenWidth! * 1, 40),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: COLOR_PURPLE),
              )
            ),
            onPressed: () {},
            child: Text(
              "Done",
             style: Theme.of(context).textTheme.bodyText1!.copyWith(
               color: COLOR_PURPLE,
             ),

            )
          )
        ],
      ),
    );
  }
}
