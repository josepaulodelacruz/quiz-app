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
import 'package:rte_app/screens/home/widgets/article_card_widget.dart';
import 'package:rte_app/screens/home/widgets/category_section.dart';
import 'package:rte_app/screens/home/widgets/continue_reading_section.dart';
import 'package:rte_app/screens/home/widgets/header_section.dart';
import 'package:rte_app/screens/home/widgets/trending_article_section.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: BlocBuilder<ArticlesBloc, ArticlesState>(
        builder: (context, state) {
          List<Tag> tags = BlocProvider.of<TagBloc>(context).state.selectedTags;
          List<Article> articles = tags.length > 0 ? state.sortedArticles: state.articles;
          List<Article> unfinishedArticles = state.unfinishedReadArticles;
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
                    if(unfinishedArticles.length > 0) ...[
                      ContinueReadingSection(unfinishedReadArticles: unfinishedArticles),
                    ],
                    CategorySection(),
                    _articleTrendingSection(state, articles),
                    if(articles.length > 0) ...[
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
                          ...articles.map((article) {
                            return Container(margin: EdgeInsets.symmetric(vertical: 5),
                                child: ArticleCardWidget(article: article));
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
    );
  }

  Widget _articleTrendingSection (state, articles) {
    if(state.status == ArticleStatus.loading) {
      return Padding(
          padding: EdgeInsets.all(20),
          child: LinearProgressIndicator()
      );
    } else if (state.status == ArticleStatus.success) {
      return TrendingArticleSection(articles: articles);
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          state.message,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
            color: COLOR_PURPLE,
          ),
        ),
      );
    }
  }
}
