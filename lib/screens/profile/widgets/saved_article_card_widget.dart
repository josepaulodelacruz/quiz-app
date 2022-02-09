import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';

class SavedArticleCardWidget extends StatelessWidget {
  const SavedArticleCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: 150,
      child: Card(
          child: Column(
            children: [
              Flexible(
                  flex: 2,
                  child: Placeholder()
              ),
              Flexible(
                flex: 1,
                child: ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  title: Text(
                    "Military Heart",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      height: 1.5,
                      fontSize: SizeConfig.blockSizeVertical! * 1.8,
                    ),
                  ),
                  subtitle: Text(
                    "Sample 1",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontSize: SizeConfig.blockSizeVertical! * 1.5,
                      color: COLOR_DARK_GRAY,
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
