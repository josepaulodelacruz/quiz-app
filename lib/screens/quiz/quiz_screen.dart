import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/utils.dart';
import 'package:rte_app/common/widgets/ads_banner_widget.dart';
import 'package:rte_app/models/article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/models/question.dart';

class QuizScreen extends StatefulWidget {
  final Article article;

  const QuizScreen({Key? key, required this.article}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  AppUtil _appUtil = AppUtil();
  int pageIndex = 1;
  int _index = 0;
  late List<Map<String, dynamic>> result;
  Timer? _timer;
  int timeLimit = 60;
  double timePercentageLimit = 0;
  final controller = PageController();
  late List<Question> questions;

  @override
  void initState() {
    questions = BlocProvider.of<ArticlesBloc>(context).state.questions;
    result = List.generate(questions.length, (index) => {});
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (timer.tick > 60) {
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
  void dispose() {
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
            icon: Icon(Icons.arrow_back_ios, color: COLOR_PINK)),
        title: Text(
          "Back",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: COLOR_PURPLE,
              fontSize: SizeConfig.blockSizeVertical! * 2.5),
        ),
        titleSpacing: -10,
      ),
      body: BlocListener<ArticlesBloc, ArticlesState>(
        listener: (context, state) {
          switch (state.status) {
            case ArticleStatus.loading:
              _appUtil.modalHudLoad(context);
              break;
            case ArticleStatus.success:
              Navigator.pop(context);
              Navigator.pushNamed(context, quiz_completed, arguments: state.overall);
              break;
            case ArticleStatus.failed:
              Navigator.pop(context);
              if(state.title != "") {
                _appUtil.errorModal(context,
                    title: state.title, message: state.message);
              }
              break;
            default:
              break;
          }
        },
        child: SizedBox(
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
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 25),
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                              color: COLOR_PINK,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  width: SizeConfig.screenWidth! *
                                      timePercentageLimit,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${_timer!.tick.toString()} sec",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.white),
                                      ),
                                      Icon(Icons.access_time_outlined,
                                          color: Colors.white)
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
                                  text: "Question ${pageIndex} /",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: COLOR_PURPLE,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: " 5",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: COLOR_PURPLE,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    )
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "____________________________________________________________________________________",
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: COLOR_PURPLE),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        // physics: NeverScrollableScrollPhysics(),
                        controller: controller,
                        onPageChanged: (int index) {
                          pageIndex = index + 1;
                          _index = index;
                          setState(() {});
                        },
                        children: questions.map((question) {
                          int index = questions.indexOf(question);
                          return _questionSection(question, index);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      height: 50,
                      width: SizeConfig.screenWidth,
                      child: AdsBannerWidget()),
                )
              ],
            )),
      ),
      floatingActionButton: (pageIndex == questions.length && result[_index].isNotEmpty)
          ? FloatingActionButton(
        onPressed: () {
          _timer!.cancel();
          context
              .read<ArticlesBloc>()
              .add(RemoveUnfinishedReadArticle(id: widget.article.id));
          context
            .read<ArticlesBloc>()
            .add(ScoreProcess(
              result: result,
              questions: questions,
              userId: BlocProvider.of<AuthBloc>(context).state.user!.id!,
              articleId: widget.article.id!,
          ));
          // Navigator.pushNamed(context, quiz_completed);
        },
        child: Icon(Icons.check),
      ) : SizedBox(),
    );
  }

  Widget _questionSection(Question question, int index) {
    return Container(
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
            question.ask!,
            style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: SizeConfig.blockSizeVertical! * 2.3,
            ),
          ),
          Spacer(),
          ...question.answers!.map((choice) {
            int answerIndex = question.answers!.indexOf(choice);
            return _answerRadio(
              choice,
              onChanged: (val) {
                _appUtil.confirmModal(
                  context,
                  title: "Are you sure?",
                  message: "If you're sure in your answer \n${val}?",
                  onPressed: () {
                    result[_index] = {
                      'answer': val,
                      'question_id': choice.questionId,
                      'answer_id': choice.id,
                    };
                    controller.animateToPage(_index + 1, duration: Duration(milliseconds: 500), curve: Curves.ease);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  cancelBtn: true,
                );
              }

            );
          }).toList(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _answerRadio(Answer answer, {required onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: COLOR_PURPLE),
      ),
      child: ListTile(
        title: Text(
          answer.answer!,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontSize: SizeConfig.blockSizeVertical! * 2.5),
        ),
        trailing: Radio(
          value: answer.answer!,
          groupValue: result[_index]['answer'],
          onChanged: (val) {
            onChanged(val);
          },
          activeColor: COLOR_PINK,
        ),
      ),
    );
  }
}
