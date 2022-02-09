import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/widgets/primary_button_widget.dart';

class OnboardingMainScreen extends StatefulWidget {
  @override
  _OnboardingMainScreenState createState() => _OnboardingMainScreenState();
}

class _OnboardingMainScreenState extends State<OnboardingMainScreen> {
  CarouselController carouselController = CarouselController();
  int pageIndex = 0;
  List<Widget> onboardScreens = [FirstOnboardingScreen(), SecondOnboardingScreen(), ThirdOnboardingScreen()];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SizedBox(
        height: SizeConfig.screenHeight!,
        width: SizeConfig.screenWidth,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1,child: SizedBox()),
            Expanded(
              flex: 2,
              child: CarouselSlider(
                items: onboardScreens,
                carouselController: carouselController,
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  height: SizeConfig.screenHeight!,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      pageIndex = index;
                    });
                    print(pageIndex);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButtonWidget(
                  onPressed: () {
                    if(pageIndex < (onboardScreens.length - 1)) {
                      pageIndex += 1;
                      carouselController.nextPage();
                    } else {
                      Navigator.pushNamed(context, launch_screen);
                    }
                    setState(() {});
                  },
                  child: Text(
                    pageIndex == (onboardScreens.length - 1) ? "GET STARTED" : "NEXT",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: COLOR_WHITE,
                      fontSize: SizeConfig.blockSizeVertical! * 2.5,
                      letterSpacing: 5,
                    ),
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20, left: 20, bottom: SizeConfig.blockSizeVertical! * 10, top: SizeConfig.blockSizeVertical! * 5),
              child: Row(
                children: <Widget>[
                  for(int i = 0 ; i < onboardScreens.length ; i++) Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        carouselController.animateToPage(i);
                        setState(() {});
                      },
                      child: Container(
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                            color: i == pageIndex ? COLOR_PINK : Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(50))
                        ),
                      ),
                    ),
                  )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FirstOnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Earn Gem",
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontSize: SizeConfig.blockSizeVertical! * 6, color: COLOR_PURPLE),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical! * 3, bottom: SizeConfig.blockSizeVertical! * 10),
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                color: COLOR_PURPLE,
                fontSize: SizeConfig.blockSizeVertical! * 2.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class SecondOnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Read to earn",
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontSize: SizeConfig.blockSizeVertical! * 6, color: COLOR_PURPLE),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical! * 3, bottom: SizeConfig.blockSizeVertical! * 10),
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                color: COLOR_PURPLE,
                fontSize: SizeConfig.blockSizeVertical! * 2.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThirdOnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How it works",
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontSize: SizeConfig.blockSizeVertical! * 6, color: COLOR_PURPLE),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical! * 3, bottom: SizeConfig.blockSizeVertical! * 10),
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                color: COLOR_PURPLE,
                fontSize: SizeConfig.blockSizeVertical! * 2.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}