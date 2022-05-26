import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/screen_arguments.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';

class SavedArticleCardWidget extends StatelessWidget {
  final Article article;

  const SavedArticleCardWidget({Key? key, required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight,
      width: 150,
      child: GestureDetector(
        onTap: () {
          context.read<ArticlesBloc>().add(CurrentReadArticle(article: article));
          context.read<ArticlesBloc>().add(ArticleGetContentEvent(id: article.id!));
          context.read<ArticlesBloc>().add(GetViolations());
          Navigator.pushNamed(context, read_article,
              arguments: ScreenArguments(
                  article: article, isViewedSavedArticle: true));
        },
        child: Card(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: CachedNetworkImage(
                imageUrl: '${dev_endpoint}/articles/articles-default.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              flex: 1,
              child: ListTile(
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                title: Text(
                  article.articleTitle!,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        height: 1.5,
                        fontSize: SizeConfig.blockSizeVertical! * 1.8,
                      ),
                ),
                subtitle: Text(
                  article.author!,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontSize: SizeConfig.blockSizeVertical! * 1.5,
                        color: COLOR_DARK_GRAY,
                      ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
