import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';

class SearchCardArticleWidget extends StatelessWidget {
  Map<String, dynamic>? result;
  final VoidCallback? onPressed;
  SearchCardArticleWidget({Key? key, this.result, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: .2,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result!['article_title'].toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 10),
              Text(
                result!['article_preview'].toString(),
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize: SizeConfig.blockSizeVertical! * 1.6,
                  color: COLOR_DARK_GRAY
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(onPressed: null, icon: Icon(Icons.save), label: Text(result!['saves'].toString())),
                  TextButton.icon(onPressed: null, icon: Icon(Icons.favorite), label: Text(result!['likes'].toString())),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}

