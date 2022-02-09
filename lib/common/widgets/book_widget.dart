import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/screens/article/show_article_screen.dart';

class BookWidget extends StatelessWidget {
  final Article article;
  final bool continueReading;

  const BookWidget({Key? key, required this.article, this.continueReading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, view_article, arguments: article);
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Center(
              child: !continueReading ? Hero(
                tag:  article.id!,
                child: CachedNetworkImage(
                  imageUrl: '${dev_endpoint}/articles/articles-default.jpg',
                  fit: BoxFit.contain,
                ),
              ) : CachedNetworkImage(
                imageUrl: '${dev_endpoint}/articles/articles-default.jpg',
                fit: BoxFit.contain,
              )
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                article.articleTitle!,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Name",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black, fontSize: SizeConfig.blockSizeVertical! * 1.2),
                  ),
                  Text(
                    "|",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black, fontSize: SizeConfig.blockSizeVertical! * 1.2),
                  ),
                  Text(
                    "Dec 12, 2021",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black, fontSize: SizeConfig.blockSizeVertical! * 1.2),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
