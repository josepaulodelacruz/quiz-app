import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';

class SearchCardArticleWidget extends StatelessWidget {
  Map<String, dynamic>? result;
  final VoidCallback? onPressed;
  SearchCardArticleWidget({Key? key, this.result, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(result);
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 180,
        child: Card(
          margin: EdgeInsets.all(10),
          elevation: .2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl:
                '${dev_endpoint}/articles/articles-default.jpg',
                height: 80,
                width: SizeConfig.screenWidth,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Text(
                    result!['article_title'].toString(),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: SizeConfig.blockSizeVertical! * 1.7,
                    ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${result!['likes'].toString()}",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: SizeConfig.blockSizeVertical! * 1.7,
                        color: COLOR_PURPLE,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.favorite, size: SizeConfig.blockSizeVertical! * 1.5, color: COLOR_PURPLE),
                  ],
                ),
              ),
              // SizedBox(height: 10),
              // Text(
              //   result!['article_preview'].toString(),
              //   style: Theme.of(context).textTheme.subtitle1!.copyWith(
              //     fontSize: SizeConfig.blockSizeVertical! * 1.6,
              //     color: COLOR_DARK_GRAY
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton.icon(onPressed: null, icon: Icon(Icons.save), label: Text(result!['saves'].toString())),
              //     TextButton.icon(onPressed: null, icon: Icon(Icons.favorite), label: Text(result!['likes'].toString())),
              //   ],
              // ),
            ],
          )
        ),
      ),
    );
  }
}

