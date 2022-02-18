import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/models/screen_arguments.dart';

class SavedLikesScreen extends StatelessWidget {
  const SavedLikesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_GRAY,
      appBar: AppBar(
        backgroundColor: COLOR_PINK,
        centerTitle: true,
        title: Text('Saved'),
      ),
      body: BlocBuilder<ArticlesBloc, ArticlesState>(
        builder: (context, state) {
          return SizedBox(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              child: GridView.builder(
                itemCount: state.likesArticles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (_, int index) {
                  return InkWell(
                    onTap: () {
                      context.read<ArticlesBloc>().add(CurrentReadArticle(article: state.likesArticles[index]));
                      Navigator.pushNamed(context, read_article,
                          arguments: ScreenArguments(
                              article: state.likesArticles[index], isViewedSavedArticle: true));
                    },
                    child: Container(
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
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    '${dev_endpoint}/articles/articles-default.jpg',
                                    width: SizeConfig.screenWidth,
                                    height: SizeConfig.screenHeight,
                                    fit: BoxFit.cover,
                                  ),
                              ),
                            ),
                            Text(
                                state.likesArticles[index].articleTitle!,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                  color: COLOR_PURPLE,
                                )
                            )
                          ],
                        )
                    ),
                  );
                },
              )
          );
        }
      ),
    );
  }
}
