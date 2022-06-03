import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/models/article.dart';

class SeeAllScreen extends StatefulWidget {
  final List<Article> articles;
  const SeeAllScreen({Key? key, this.articles = const []}) : super(key: key);

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: COLOR_LIGHT_GRAY.withOpacity(.9),
      appBar: AppBar(
        title: Text("Articles"),
      ),
      body: ListView(
        children: widget.articles.map((article) {
          return _articleCard(article);
        }).toList(),
      )
    );
  }

  Widget _articleCard(Article article) {
    return Container(
      height: SizeConfig.screenHeight! * .50,
      margin: EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            ListTile(
              title: Text(
                article.articleTitle!,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                article.author!,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: COLOR_DARK_GRAY,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ),
            Flexible(
              child: CachedNetworkImage(
                imageUrl: '${dev_endpoint}/articles/articles-default.jpg',
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, color: COLOR_PURPLE, size: SizeConfig.blockSizeVertical! * 1.5),
                  SizedBox(width: 5),
                  Text(
                    "${article.likes} likes",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: SizeConfig.blockSizeVertical! * 1.5,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "10 comments",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: SizeConfig.blockSizeVertical! * 1.5,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: CircleAvatar(
                      backgroundColor: COLOR_DARK_GRAY,
                      radius: 1.5,
                    ),
                  ),
                  Text(
                    "${article.saves} saves",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: SizeConfig.blockSizeVertical! * 1.5,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1.5),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(onPressed: null, icon: Icon(Icons.favorite), label: Text("Like")),
                  TextButton.icon(onPressed: null, icon: Icon(Icons.comment), label: Text("Comment")),
                  TextButton.icon(onPressed: null, icon: Icon(Icons.save), label: Text("Save")),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
