import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/models/article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/models/screen_arguments.dart';
import 'package:rte_app/screens/article/show_article_screen.dart';

class SavedCategorizeArticleScreen extends StatefulWidget {
  final String pageName;
  final List<Article> categorizedArticles;

  const SavedCategorizeArticleScreen({
    Key? key,
    this.pageName = "",
    this.categorizedArticles = const [],
  }) : super(key: key);

  @override
  State<SavedCategorizeArticleScreen> createState() => _SavedCategorizeArticleScreenState();
}

class _SavedCategorizeArticleScreenState extends State<SavedCategorizeArticleScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_PINK,
        centerTitle: true,
        title: Text(widget.pageName),
      ),
      body: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: widget.categorizedArticles.length,
        itemBuilder: (_, int index) {
          return GestureDetector(
            onTap: () {
              context.read<ArticlesBloc>().add(CurrentReadArticle(article: widget.categorizedArticles[index]));
              context.read<ArticlesBloc>().add(ArticleGetContentEvent(id: widget.categorizedArticles[index].id!));
              context.read<ArticlesBloc>().add(GetViolations());
              Navigator.pushNamed(context, read_article,
                  arguments: ScreenArguments(
                      article: widget.categorizedArticles[index], isViewedSavedArticle: true));
            },
            child: SizedBox(
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: '${dev_endpoint}/articles/articles-default.jpg',
                      fit: BoxFit.contain,
                    ),
                    ListTile(
                      title: Text(
                        widget.categorizedArticles[index].articleTitle.toString(),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      subtitle: Text(
                        widget.categorizedArticles[index].author.toString(),
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: COLOR_DARK_GRAY,
                          fontSize: SizeConfig.blockSizeVertical! * 1.7,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
