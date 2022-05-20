import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/widgets/book_widget.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/pagination.dart';

class GetArticleSection extends StatelessWidget {
  final List<Article> articles;
  final VerifiedArticlePagination verifiedArticlePagination;

  const GetArticleSection({Key? key, required this.articles, required this.verifiedArticlePagination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20),
        ListTile(
          title: Text(
            "Articles",
            style: Theme.of(context).textTheme.headline5!,
          ),
          trailing: TextButton(
            onPressed: () {},
            child: Text(
                "See all",
                style: TextStyle(color: COLOR_PURPLE)
            ),
          ),
        ),
        SizedBox(
            height: 170,
            child: articles.length > 0 ? NotificationListener<ScrollEndNotification>(
              onNotification: (scrollEnd) {
                final metrics = scrollEnd.metrics;
                if (metrics.atEdge) {
                  bool isTop = metrics.pixels == 0;
                  if (!isTop) {
                    context.read<ArticlesBloc>().add(VerifiedArticlesNextScroll(verifiedArticlePagination: verifiedArticlePagination));
                  }
                }
                return true;
              },
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: articles.map((article) {
                  return BookWidget(article: article);
                }).toList(),
              ),
            ) : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "No Found Article related to selected Category",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: COLOR_PURPLE,
                  fontSize: SizeConfig.blockSizeVertical! * 2.5,
                ),
              ),
            )
        )
      ],
    );
  }
}
