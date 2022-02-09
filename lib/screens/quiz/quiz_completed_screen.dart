import 'package:flutter/material.dart';
import 'package:rte_app/blocs/ads/ads_bloc.dart';
import 'package:rte_app/blocs/ads/ads_event.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/widgets/ads_banner_widget.dart';
import 'package:rte_app/common/widgets/primary_button_widget.dart';
import 'package:rte_app/common/widgets/transparent_app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizCompletedScreen extends StatelessWidget {
  const QuizCompletedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: TransparentAppBarWidget(),
      body: SizedBox(
        height: SizeConfig.screenHeight!,
        width: SizeConfig.screenWidth!,
        child: Stack(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _scoreSection(context),
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: PrimaryButtonWidget(
                    onPressed: () {
                      context.read<AdsBloc>().add(ClearAds());
                      Navigator.pushNamedAndRemoveUntil(context, 'main_layout', (route) => false);
                    },
                    color: COLOR_PINK,
                    child: Text(
                      "EARN MORE",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.blockSizeVertical! * 2.5,
                        letterSpacing: 6,
                        color: Colors.white,
                      ),
                    ),
                  )
                ),
                SizedBox(height: 50),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(height: 50, child: AdsBannerWidget()),
            )
          ],
        )
      ),
    );
  }

  Widget _scoreSection(context) {
    return Column(
      children: [
        Text(
          "COMPLETED!",
          style: Theme.of(context).textTheme.headline5!.copyWith(
            color: COLOR_PURPLE,
            fontSize: SizeConfig.blockSizeVertical! * 5,
          ),
        ),
        SizedBox(height: 30),
        CircleAvatar(
          backgroundColor: COLOR_PURPLE.withOpacity(.1),
          radius: SizeConfig.blockSizeVertical! * 17,
          child: CircleAvatar(
            backgroundColor: COLOR_PURPLE.withOpacity(.5),
            radius: SizeConfig.blockSizeVertical! * 14,
            child: CircleAvatar(
              backgroundColor: COLOR_PURPLE,
              radius: SizeConfig.blockSizeVertical! * 11,
              child: CircleAvatar(
                backgroundColor: COLOR_WHITE,
                radius: SizeConfig.blockSizeVertical! * 9.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "100%",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontSize: SizeConfig.blockSizeVertical! * 4.5,
                        color: COLOR_PINK,
                      ),
                    ),
                    Text(
                      "5/5",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontSize: SizeConfig.blockSizeVertical! * 4.5,
                        color: COLOR_PINK,
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Congratulation and you've earned\n 10. PHP.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: SizeConfig.blockSizeVertical! * 2.5,
              color: Colors.grey,
              letterSpacing: 2,
            ),
          ),
        )
      ],
    );
  }

}
