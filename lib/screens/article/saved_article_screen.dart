import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';

class SavedArticleScreen extends StatefulWidget {
  const SavedArticleScreen({Key? key}) : super(key: key);

  @override
  _SavedArticleScreenState createState() => _SavedArticleScreenState();
}

class _SavedArticleScreenState extends State<SavedArticleScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: COLOR_GRAY,
      appBar: AppBar(
        backgroundColor: COLOR_PINK,
        centerTitle: true,
        title: Text('Saved'),
      ),
      body: SizedBox(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: GridView.builder(
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemBuilder: (_, int index) {
              return Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        height: SizeConfig.screenHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GridView.builder(
                          itemCount: 4,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemBuilder: (_, int index) {
                            return Container(
                              color: COLOR_PURPLE.withOpacity(.2),
                            );
                          },
                        )
                      ),
                    ),
                    Text(
                      "Articles",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: COLOR_PURPLE,
                      )
                    )
                  ],
                )
              );
            },
        )
      ),
    );
  }
}
