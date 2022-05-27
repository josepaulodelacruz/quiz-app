import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/models/article.dart';

class SavedArticleScreen extends StatefulWidget {
  const SavedArticleScreen({Key? key}) : super(key: key);

  @override
  _SavedArticleScreenState createState() => _SavedArticleScreenState();
}

class _SavedArticleScreenState extends State<SavedArticleScreen> {
  List<dynamic> categories = [];
  Map<String, dynamic> sortedArticles = {};

  @override
  void initState () {
    List a = BlocProvider.of<ArticlesBloc>(context).state.getSavedArticles.map((article) {
      return article.category!.name;
    }).toList();
    categories = a.toSet().toList();
    categories.map((category) {
      sortedArticles[category] = [];
      BlocProvider.of<ArticlesBloc>(context).state.getSavedArticles.map((article) {
        if(article.category!.name == category) {
          sortedArticles[category].add(article);
        }
      }).toList();
    }).toList();
    super.initState();
  }

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
              itemCount: categories.length,
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
                                itemBuilder: (_, int subIndex) {
                                  if(sortedArticles[categories[index]].length > subIndex) {
                                    return SizedBox(
                                      child: CachedNetworkImage(
                                        imageUrl: '${dev_endpoint}/articles/articles-default.jpg',
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      color: COLOR_PURPLE.withOpacity(.2),
                                    );
                                  }
                                },
                              )
                          ),
                        ),
                        Text(
                            "${categories[index]}",
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                              color: COLOR_PURPLE,
                            )
                        )
                      ],
                    )
                );
              },
            )
        )
    );
  }
}
