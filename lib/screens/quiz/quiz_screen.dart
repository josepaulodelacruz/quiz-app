import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/widgets/ads_banner_widget.dart';
import 'package:rte_app/models/article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizScreen extends StatefulWidget {
  final Article article;

  const QuizScreen({Key? key, required this.article}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  Timer? _timer;
  int timeLimit = 60;
  double timePercentageLimit = 0;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if(timer.tick > 60) {
        _timer!.cancel();
      } else {
        double currentTime = timer.tick / timeLimit;
        timePercentageLimit = currentTime;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose () {
    _timer!.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: COLOR_GRAY,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: COLOR_PINK)
        ),
        title: Text(
          "Back",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: COLOR_PURPLE, fontSize: SizeConfig.blockSizeVertical! * 2.5),
        ),
        titleSpacing: -10,
      ),
      body: SizedBox(
        height: SizeConfig.screenHeight!,
        width: SizeConfig.screenWidth!,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          color: COLOR_PINK,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: SizeConfig.screenWidth! * timePercentageLimit,
                              height: SizeConfig.screenHeight,
                              decoration: BoxDecoration(
                                color: COLOR_PURPLE,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Container(
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenHeight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${_timer!.tick.toString()} sec",
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                                  ),
                                  Icon(Icons.access_time_outlined, color: Colors.white)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(
                          TextSpan(
                            text: "Question 1 /",
                            style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: COLOR_PURPLE,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: " 5",
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: COLOR_PURPLE,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ]
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "____________________________________________________________________________________",
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: COLOR_PURPLE),
                        ),
                      )
                    ],
                  )
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "What is RTE?",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Spacer(),
                        _answerRadio(label: "Answers 1"),
                        _answerRadio(label: "Answers 2"),
                        _answerRadio(label: "Answers 3"),
                        _answerRadio(label: "Answers 4"),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(height: 50, width: SizeConfig.screenWidth, child: AdsBannerWidget()),
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _timer!.cancel();
          context.read<ArticlesBloc>().add(RemoveUnfinishedReadArticle(id: widget.article.id));
          Navigator.pushNamed(context, quiz_completed);
        },
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _questionSection() {
    return Container(
      margin: EdgeInsets.all(20),
      height: 300,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 100,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "<Questionaire Here>",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.white),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: COLOR_PURPLE,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding:
                  EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "1 / 5",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: COLOR_PURPLE,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerRadio ({required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: COLOR_PURPLE),
      ),
      child: ListTile(
        title: Text(
          "$label",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: SizeConfig.blockSizeVertical! * 2.5
          ),
        ),
        trailing: Radio(
          value: label,
          groupValue: label,
          onChanged: (val) {},
          activeColor: COLOR_PINK,
        ),
      ),
    );
  }
}