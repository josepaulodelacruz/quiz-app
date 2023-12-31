import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/tags/tag_bloc.dart';
import 'package:rte_app/blocs/tags/tag_state.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/screens/article/show_article_screen.dart';

class ArticleCardWidget extends StatelessWidget {
  final Article article;

  const ArticleCardWidget({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          context.read<ArticlesBloc>().emit(context.read<ArticlesBloc>().state.copyWith(currentRead: article));
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              isDismissible: false,
              builder: (_) => DraggableScrollableSheet(
                initialChildSize: 1,
                builder: (_, scrollController) {
                  return ShowArticleScreen();
                },
              )
          );
        },
        child: Card(
          child: SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  width: 80,
                  child: CachedNetworkImage(
                      imageUrl: '${dev_endpoint}/articles/articles-default.jpg',
                      fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article.articleTitle!,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                            fontSize: SizeConfig
                                .blockSizeVertical! *
                                2.3,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Chip(
                              backgroundColor: COLOR_PURPLE,
                              visualDensity: VisualDensity(
                                  horizontal: -4, vertical: -4),
                              label: Text(
                                article.category!.name!,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            // Chip(
                            //   backgroundColor: COLOR_PURPLE,
                            //   visualDensity: VisualDensity(
                            //       horizontal: -4, vertical: -4),
                            //   label: Text(
                            //     "...",
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                            Spacer(),
                            Chip(
                                backgroundColor: Colors.transparent,
                                visualDensity: VisualDensity(
                                    horizontal: -4, vertical: -4),
                                avatar: Icon(Icons.visibility, size: 12),
                                label: Text(
                                  article.views.toString(),
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                                )
                            ),
                            Chip(
                                backgroundColor: Colors.transparent,
                                visualDensity: VisualDensity(
                                    horizontal: -4, vertical: -4),
                                avatar: Icon(Icons.bookmark, size: 12,),
                                label: Text(
                                  article.likes.toString(),
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                                )
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
