import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:rte_app/blocs/auth/auth_state.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/user.dart';
import 'package:rte_app/screens/profile/widgets/saved_article_card_widget.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  String? isViewUser;

  ProfileScreen({Key? key, this.isViewUser}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen>{
  late User author;
  late User user;
  late User viewedUser;

  @override
  void initState() {
    if(widget.isViewUser == "author") {
      author = context.read<AuthBloc>().state.viewedAuthor!;
    }

    if(widget.isViewUser == "view") {
      viewedUser = context.read<AuthBloc>().state.viewedUser!;
    }

    user = context.read<AuthBloc>().state.user!;
    super.initState();
  }

  String urlPicture () {
    if(widget.isViewUser == "author") {
      return author.profilePhoto!;
    } else if(widget.isViewUser == "view") {
      return viewedUser.profilePhoto!;
    } else {
      return user.profilePhoto!;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 50, bottom: 25),
                child: CircleAvatar(
                  radius: SizeConfig.blockSizeVertical! * 12,
                  backgroundColor: COLOR_PURPLE,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(urlPicture()),
                    radius: SizeConfig.blockSizeVertical! * 11.5,
                    backgroundColor: Colors.white,
                  ),
                )
            ),
            if(widget.isViewUser == 'auhtor') ...[
              Text(
                "${author.firstName} ${author.lastName}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: COLOR_PURPLE,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ] else if(widget.isViewUser == "view") ...[
              Text(
                "${viewedUser.firstName} ${viewedUser.lastName}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: COLOR_PURPLE,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ] else ...[
              Text(
                "${user.firstName} ${user.lastName}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: COLOR_PURPLE,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Text.rich(
                  TextSpan(
                      children: [
                        TextSpan(
                          text: "Philippines ",
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: COLOR_PURPLE
                          ),
                        ),
                        TextSpan(
                          text: "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().isUtc ? "AM": "PM"}",
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.grey
                          ),
                        )
                      ]
                  )
              ),
            ),
            earnSection(context),
            SizedBox(height: 20),
            if(widget.isViewUser == "author") ...[
              Expanded(child: savedArticleSection(context, author.articles!)),
            ] else if(widget.isViewUser == "view") ...[
              Expanded(child: savedArticleSection(context, viewedUser.articles!)),
            ] else ...[
              BlocBuilder<ArticlesBloc, ArticlesState>(
                  builder: (context, articleState) {
                    if(widget.isViewUser == null) {
                      return Expanded(child: savedArticleSection(context, articleState.getSavedArticles, status: articleState.status));
                    }
                    return SizedBox();
                  }
              )
            ],
          ],
        ),
      )
    );
  }

  Widget earnSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "24k+",
                style: Theme.of(context).textTheme.headline5!.copyWith(color: COLOR_PURPLE),
              ),
              SizedBox(height: 10),
              Text(
                "Unclaimed Earnings",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(color: COLOR_PURPLE),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "24k+",
                style: Theme.of(context).textTheme.headline5!.copyWith(color: COLOR_PURPLE),
              ),
              SizedBox(height: 10),
              Text(
                "Total Earnings",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(color: COLOR_PURPLE),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1,450",
                style: Theme.of(context).textTheme.headline5!.copyWith(color: COLOR_PURPLE),
              ),
              SizedBox(height: 10),
              Text(
                "Hours Spent",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(color: COLOR_PURPLE),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget savedArticleSection (context, List<Article> articles, {ArticleStatus? status}) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, saved_article_screen);
          },
          title: Text(
            widget.isViewUser == 'author' ? "Written Articles" : "Saved Article",
            style: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.w500,
            )
          ),
          trailing: Text(
            "See All",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: COLOR_PURPLE, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  ...articles.map((article) {
                    return SavedArticleCardWidget(article: article);
                  }).toList()
                ],
              )
            )
          ),
        ),
      ],
    );
  }
}
