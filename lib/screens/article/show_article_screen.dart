import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rte_app/blocs/ads/ads_bloc.dart';
import 'package:rte_app/blocs/ads/ads_event.dart';
import 'package:rte_app/blocs/ads/ads_state.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:rte_app/blocs/auth/auth_event.dart';
import 'package:rte_app/blocs/auth/auth_state.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/common/utils.dart';
import 'package:rte_app/common/widgets/primary_button_widget.dart';
import 'package:rte_app/models/article.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rte_app/models/screen_arguments.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowArticleScreen extends StatelessWidget {
  final AppUtil _appUtil = AppUtil();
  final int? index;

  ShowArticleScreen({Key? key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: BlocListener<AdsBloc, AdsState>(
        listener: (context, state) {
          if (state.status == AdsStatus.loading) {
            _appUtil.modalHudLoad(context);
          } else if (state.status == AdsStatus.failed) {
            Navigator.pop(context);
          } else if (state.status == AdsStatus.success) {
            Navigator.pop(context);
            // state.fileInfo!.listen((event) {},
            //   onDone: () {
            //     Navigator.pop(context);
            //   },
            //   onError: (error) {
            //     Navigator.pop(context);
            //     print(error);
            //   }
            // );

            Navigator.pushNamed(context, read_article,
                arguments: ScreenArguments(
                    article: BlocProvider.of<ArticlesBloc>(context)
                        .state
                        .currentRead));
          }
        },
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.loading) {
              _appUtil.modalHudLoad(context);
            } else if (state.status == AuthStatus.success) {
              Navigator.pop(context);
            } else if (state.status == AuthStatus.failed) {
              Navigator.pop(context);
            } else if (state.status == AuthStatus.viewAuthor) {
              Navigator.pop(context);
              Navigator.pushNamed(context, profile_screen, arguments: "author");
            } else if (state.status == AuthStatus.viewUser) {
              Navigator.pop(context);
              Navigator.pushNamed(context, profile_screen, arguments: "view");
            }
          },
          child: BlocBuilder<ArticlesBloc, ArticlesState>(
              builder: (context, state) {
            Article article = state.currentRead;
            return SafeArea(
              child: SizedBox(
                height: SizeConfig.screenHeight!,
                width: SizeConfig.screenWidth!,
                child: Column(
                  children: [
                    Container(
                      color: Colors.lightBlue,
                      height: SizeConfig.screenHeight! * .25,
                      child: Stack(
                        children: [
                          Hero(
                            tag: article.id!,
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${dev_endpoint}/articles/articles-default.jpg',
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenHeight,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: CircleAvatar(
                                    backgroundColor:
                                        Colors.black.withOpacity(.5),
                                    child: Icon(Icons.close)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              article.articleTitle!,
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Html(
                                data: article.articleContent
                                    .toString()
                                    .substring(0, 50),
                              ),
                              subtitle: InkWell(
                                onTap: () async {
                                  context.read<AuthBloc>().add(AuthViewAuthor(
                                      authorId: article.authorId!));
                                },
                                child: Text(
                                  "Writer: ${article.author!}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: COLOR_DARK_GRAY,
                                      ),
                                ),
                              ),
                              trailing: Text(
                                timeago.format(DateTime.parse(article.date!)),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      height: 3.5,
                                      color: COLOR_DARK_GRAY,
                                    ),
                              ),
                            ),
                            Html(
                              data: article.articleContent.toString(),
                            ),
                            SizedBox(height: 10),
                            Divider(thickness: 2),
                            Spacer(),
                            Wrap(
                              spacing: SizeConfig.blockSizeVertical! * 4,
                              runSpacing: 20,
                              children: [
                                SizedBox(
                                  width: SizeConfig.screenWidth! * .4,
                                  height: 50,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Container(
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreenAccent
                                            .withOpacity(.5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    title: Text(
                                      "Category",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize:
                                                SizeConfig.blockSizeVertical! *
                                                    1.8,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    subtitle: Text(
                                      article.category!.name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth! * .4,
                                  height: 50,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Container(
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.withOpacity(.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    title: Text(
                                      "Saved",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize:
                                                SizeConfig.blockSizeVertical! *
                                                    1.8,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    subtitle: Text(
                                      "${article.saves}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if(article.viewedUsers!.isEmpty) return;
                                    _showUserViews(context, article);
                                  },
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth! * .4,
                                    height: 50,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Container(
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.orangeAccent
                                              .withOpacity(.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      title: Text(
                                        "Views",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: SizeConfig
                                                      .blockSizeVertical! *
                                                  1.8,
                                              color: Colors.orangeAccent,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      subtitle: Text(
                                        article.views.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: Colors.orangeAccent,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            PrimaryButtonWidget(
                              onPressed: () {
                                int userId = BlocProvider.of<AuthBloc>(context)
                                    .state
                                    .user!
                                    .id!;
                                context.read<ArticlesBloc>().add(ArticleView(
                                    userId: userId, articleId: article.id!));
                                context
                                    .read<ArticlesBloc>()
                                    .add(CurrentReadArticle(article: article));
                                context.read<AdsBloc>().add(RandomGetAds());
                                context.read<ArticlesBloc>().add(
                                    ArticleGetContentEvent(id: article.id!));
                                context
                                    .read<ArticlesBloc>()
                                    .add(GetViolations());
                                // Navigator.pushNamed(context, read_article, arguments: article);
                              },
                              child: Text(
                                "Read Now",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize:
                                            SizeConfig.blockSizeVertical! * 2.5,
                                        color: Colors.white,
                                        letterSpacing: 5),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showUserViews(context, article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: article.viewedUsers!.length <= 5
              ? double.parse("0.${article.viewedUsers!.length}")
              : 0.5,
          maxChildSize: 1,
          minChildSize: article.viewedUsers!.length <= 5
              ? double.parse("0.${article.viewedUsers!.length}")
              : 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: COLOR_WHITE,
              child: ListView(
                children: [
                  ...article.viewedUsers!.map((viewers) {
                    return ListTile(
                      onTap: () {
                        context
                            .read<AuthBloc>()
                            .add(AuthViewUser(userId: viewers['id']));
                      },
                      leading: CircleAvatar(
                        backgroundColor: COLOR_PURPLE,
                        child: Text(viewers['full_name'].substring(0, 1),
                            style: TextStyle(color: COLOR_WHITE)),
                      ),
                      title: Text(viewers['full_name']),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
