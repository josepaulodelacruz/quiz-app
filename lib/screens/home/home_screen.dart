import 'package:flutter/material.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/tags/tag_bloc.dart';
import 'package:rte_app/blocs/tags/tag_event.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/widgets/transparent_app_bar_widget.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/pagination.dart';
import 'package:rte_app/screens/home/widgets/article_card_widget.dart';
import 'package:rte_app/screens/home/widgets/category_section.dart';
import 'package:rte_app/screens/home/widgets/continue_reading_section.dart';
import 'package:rte_app/screens/home/widgets/get_article_section.dart';
import 'package:rte_app/screens/home/widgets/header_section.dart';
import 'package:rte_app/screens/home/widgets/trending_article_section.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> articles = [];
  ScrollController _scrollController = ScrollController();
  Color backgroundColor = Colors.transparent;
  double elevation = 0;

  @override
  void initState() {
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
          elevation: elevation, backgroundColor: backgroundColor),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ArticlesBloc, ArticlesState>(
            listener: (_, event) {
              articles = event.articles;
              setState(() {});
            },
          )
        ],
        child: BlocBuilder<ArticlesBloc, ArticlesState>(
          builder: (context, state) {
            List<Tag> tags = BlocProvider.of<TagBloc>(context).state.selectedTags;
            // List<Article> articles = tags.length > 0 ? state.sortedArticles : state.articles;
            List<Article> trendingArticles = state.trendingArticles;
            List<Article> unfinishedArticles = state.unfinishedReadArticles;
            List<Article> latestArticles = state.latestArticles;
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<ArticlesBloc>().add(ArticleGetEvent());
                  context.read<TagBloc>().add(GetTags());
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      HeaderSection(),
                      if (unfinishedArticles.length > 0) ...[
                        ContinueReadingSection(
                            unfinishedReadArticles: unfinishedArticles),
                      ],
                      CategorySection(),
                      _articleTrendingSection(state, trendingArticles),
                      if (latestArticles.length > 0) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              title: Text(
                                "Latest Articles",
                                style: Theme.of(context).textTheme.headline5!,
                              ),
                              trailing: TextButton(
                                onPressed: () {},
                                child: Text("See all",
                                    style: TextStyle(color: COLOR_PURPLE)),
                              ),
                            ),
                            ...latestArticles.map((latestArticle) {
                              return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: ArticleCardWidget(article: latestArticle));
                            }).toList(),
                            // ArticleCardWidget(),
                          ],
                        )
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _articleTrendingSection(ArticlesState state, trendingArticles) {
    if (state.status == ArticleStatus.loading) {
      return Padding(
          padding: EdgeInsets.all(20), child: LinearProgressIndicator());
    } else {
      return Column(
        children: [
          if(trendingArticles.isNotEmpty) ...[
            TrendingArticleSection(articles: trendingArticles),
          ],
          GetArticleSection(articles: articles,
              verifiedArticlePagination: state.verifiedArticlePagination),
        ],
      );
    }
    // if (state.status == ArticleStatus.loading) {
    //   return Padding(
    //       padding: EdgeInsets.all(20), child: LinearProgressIndicator());
    // } else if (state.status == ArticleStatus.success ||
    //     state.status == ArticleStatus.owner ||
    //     state.status == ArticleStatus.viewUserSavedArticle ||
    //     state.status == ArticleStatus.hideArticle ||
    //     state.status == ArticleStatus.waiting
    // ) {
    //   return Column(
    //     children: [
    //       if(trendingArticles.isNotEmpty) ...[
    //         TrendingArticleSection(articles: trendingArticles),
    //       ],
    //       GetArticleSection(articles: articles, verifiedArticlePagination: state.verifiedArticlePagination),
    //     ],
    //   );
    // } else {
    //   return Padding(
    //     padding: EdgeInsets.symmetric(horizontal: 20),
    //     child: Text(
    //       state.message,
    //       style: Theme.of(context).textTheme.subtitle1!.copyWith(
    //             color: COLOR_PURPLE,
    //           ),
    //     ),
    //   );
    // }
  }
}
