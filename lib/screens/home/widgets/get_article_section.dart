import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/widgets/book_widget.dart';
import 'package:rte_app/models/article.dart';

class GetArticleSection extends StatelessWidget {
  final List<Article> articles;

  const GetArticleSection({Key? key, required this.articles}) : super(key: key);

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
            child: articles.length > 0 ? ListView(
              scrollDirection: Axis.horizontal,
              children: articles.map((article) {
                return BookWidget(article: article);
              }).toList(),
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
