import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/blocs/ads/ads_bloc.dart';
import 'package:rte_app/blocs/ads/ads_state.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/auth/auth_event.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/utils.dart';
import 'package:rte_app/common/widgets/ads_widget.dart';
import 'package:rte_app/common/widgets/claim_reward_widget.dart';
import 'package:rte_app/common/widgets/transparent_app_bar_widget.dart';
import 'package:rte_app/common/widgets/util.dart';
import 'package:rte_app/models/ads.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/screens/article/widgets/report_form_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadArticleScreen extends StatefulWidget {
  Article article;
  bool isViewedSavedArticle;

  ReadArticleScreen({required this.article, this.isViewedSavedArticle = false});

  @override
  _ReadArticleScreenState createState() => _ReadArticleScreenState();
}

class _ReadArticleScreenState extends State<ReadArticleScreen> {
  late Article article;
  final ScrollController _scrollController = ScrollController();
  Color backgroundColor = Colors.transparent;
  final AppUtil _appUtil = AppUtil();
  double elevation = 0;

  @override
  void initState() {
    article = context.read<ArticlesBloc>().state.currentRead;
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      backgroundColor = Colors.white;
      elevation = 1;
    }

    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      backgroundColor = COLOR_GRAY;
      elevation = 0;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: TransparentAppBarWidget(
        elevation: elevation,
        backgroundColor: backgroundColor,
        onPressed: _confirmationModal,
        actions: [
          PopupMenuButton(
            onSelected: (selected) {
              if (selected == 'Save') {
                article = article.copyWith(isSaved: true, saves: article.saves! + 1);
                setState(() {});
                context.read<ArticlesBloc>().add(SavedArticle(
                      userId: BlocProvider.of<AuthBloc>(context).state.user!.id,
                      articleId: article.id,
                      article: article,
                    ));
              } else if (selected == 'Saved') {
                article = article.copyWith(isSaved: false, saves: article.saves! - 1);
                setState(() {});
                context.read<ArticlesBloc>().add(DeletedSavedArticles(
                      userId: BlocProvider.of<AuthBloc>(context).state.user!.id,
                      articleId: article.id,
                      article: article,
                    ));
                setState(() {});
              } else if (selected == "Like") {
                article = article.copyWith(isLike: true, likes: article.likes! + 1);
                setState(() {});
                context.read<ArticlesBloc>().add(LikeArticle(
                      userId: BlocProvider.of<AuthBloc>(context).state.user!.id,
                      articleId: article.id,
                      article: article,
                    ));
              } else if (selected == "Unlike") {
                article = article.copyWith(isLike: false, likes: article.likes! - 1);
                setState(() {});
                context.read<ArticlesBloc>().add(UnlikeArticle(
                      userId: BlocProvider.of<AuthBloc>(context).state.user!.id,
                      articleId: article.id,
                      article: article,
                    ));
              } else {
                context.read<ArticlesBloc>().add(ShowViolationList(isShow: true));
                context.read<ArticlesBloc>().add(GetViolations());
              }
            },
            itemBuilder: (context) => [
              !article.isSaved! && !widget.isViewedSavedArticle
                  ? PopupMenuItem(
                      value: 'Save',
                      child: TextButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.save_alt, color: COLOR_PURPLE),
                          label: Text('Save',
                              style: TextStyle(color: COLOR_PURPLE))),
                    )
                  : PopupMenuItem(
                      value: 'Saved',
                      child: TextButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.check, color: COLOR_PURPLE),
                          label: Text('Article Saved',
                              style: TextStyle(color: COLOR_PURPLE))),
                    ),
              if(!widget.isViewedSavedArticle) ...[
                !article.isLike!
                    ? PopupMenuItem(
                  value: 'Like',
                  child: TextButton.icon(
                      onPressed: null,
                      icon:
                      Icon(Icons.favorite_border, color: COLOR_PURPLE),
                      label: Text('Like',
                          style: TextStyle(color: COLOR_PURPLE))),
                )
                    : PopupMenuItem(
                  value: 'Unlike',
                  child: TextButton.icon(
                      onPressed: null,
                      icon: Icon(Icons.favorite, color: COLOR_PURPLE),
                      label: Text('Unlike',
                          style: TextStyle(color: COLOR_PURPLE))),
                ),
              ],
              PopupMenuItem(
                value: 'Report',
                child: TextButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.report, color: COLOR_PURPLE),
                    label: Text('Report', style: TextStyle(color: COLOR_PURPLE))),
              ),
            ],
          )
        ],
      ),
      body: BlocListener<ArticlesBloc, ArticlesState>(
        listener: (context, state) {
          if (mounted && !widget.isViewedSavedArticle) {
            switch (state.status) {
              case ArticleStatus.loading:
                _appUtil.modalHudLoad(context);
                break;
              case ArticleStatus.success:
                Navigator.pop(context);
                if(state.title != "" && !state.title.contains("Question fetched")) {
                  _appUtil.confirmModal(context,
                      title: state.title, message: state.message);
                } else if(state.title.contains("Question fetched")) {
                  Navigator.pushNamed(context, quiz_screen,
                      arguments: article);
                }
                article = state.currentRead;
                setState(() {});
                break;
              case ArticleStatus.failed:
                if(state.title != "") {
                  _appUtil.errorModal(context,
                      title: 'Failed to Saved Article', message: state.message);
                }
                break;
              case ArticleStatus.showViolationList:
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) =>
                    ReportFormWidget(violations: state.violations, article: article),
                );
                break;
              case ArticleStatus.hideArticle:
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pushNamedAndRemoveUntil(context, 'main_layout', (route) => true);
                break;
              default:
                break;
            }
          } else {
            switch(state.status) {
              case ArticleStatus.showViolationList:
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) =>
                      ReportFormWidget(violations: state.violations, article: article),
                );
                break;
              default:
                break;
            }
          }
        },
        child: SizedBox(
          width: SizeConfig.screenWidth!,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _articleTitleSection(context),
                _iconSection(context),
                SizedBox(height: 20),
                _articleHeroImage(context),
                _articleParagraph(context),
                BlocBuilder<AdsBloc, AdsState>(
                  builder: (context, state) {
                    Ads ads = state.ads;
                    return Column(
                      children: [
                        AdsWidget(ads: ads),
                        _bannerAds(context, ads),
                      ],
                    );
                  },
                ),
                if (!widget.isViewedSavedArticle) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: COLOR_PURPLE,
                        padding: EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => ClaimRewardWidget(
                            onPressed: () {
                              context.read<ArticlesBloc>().add(GetQuizArticle(articleId: article.id));
                            },
                          ),
                        );
                      },
                      child: Text(
                        "Claim Rewards",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _articleTitleSection(context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: "${article.articleTitle!}\n",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "By ",
              style: TextStyle(height: 2),
              children: <TextSpan>[
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () {
                    _viewAuthor();
                  },
                  text: "${article.author} ",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: COLOR_PURPLE,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextSpan(
                  text:
                      "published ${timeago.format(DateTime.parse(article.date!))}\n",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            ...article.tags!.map((tag) {
              return TextSpan(
                text: "${tag.name} ",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.blockSizeVertical! * 2,
                      height: 1.5,
                    ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _iconSection(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: FaIcon(
              FontAwesomeIcons.twitter,
            ),
          ),
          SizedBox(width: 5),
          InkWell(
            onTap: () {},
            child: Icon(Icons.facebook_outlined),
          ),
          SizedBox(width: 5),
          InkWell(
            onTap: () {},
            child: FaIcon(
              FontAwesomeIcons.linkedinIn,
            ),
          ),
          SizedBox(width: 5),
          InkWell(onTap: () {}, child: Icon(Icons.cloud_download)),
        ],
      ),
    );
  }

  Widget _articleHeroImage(context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: CachedNetworkImage(
        imageUrl: '${dev_endpoint}/articles/articles-default.jpg',
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _articleParagraph(context) {
    return BlocBuilder<ArticlesBloc, ArticlesState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 200,
          width: SizeConfig.screenWidth!,
          child: Html(
            data: state.articleContent,
          ),
        );
      }
    );
  }

  Widget _bannerAds(context, Ads ads) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: CachedNetworkImage(
        imageUrl: '${dev_endpoint}/ads/images/footer/footer-ads-default.jpg',
        placeholder: (_, __) {
          return Placeholder();
        },
      ),
    );
  }

  void _confirmationModal() {
    if (!widget.isViewedSavedArticle) {
      _appUtil.confirmModal(context,
          title: "Continue Reading",
          message: "Would you like saved this article for later?",
          cancelBtn: true, onPressed: () {
        context
            .read<ArticlesBloc>()
            .add(UnfinishedArticleRead(article: article));
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _viewAuthor () async {
    modalHudLoad(context);
    context.read<AuthBloc>().add(AuthViewAuthor(authorId: article.author.id));
    Navigator.pop(context);
  }
}
