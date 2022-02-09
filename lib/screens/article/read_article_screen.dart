import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rte_app/blocs/ads/ads_bloc.dart';
import 'package:rte_app/blocs/ads/ads_state.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/utils.dart';
import 'package:rte_app/common/widgets/ads_widget.dart';
import 'package:rte_app/common/widgets/claim_reward_widget.dart';
import 'package:rte_app/common/widgets/transparent_app_bar_widget.dart';
import 'package:rte_app/models/ads.dart';
import 'package:rte_app/models/article.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadArticleScreen extends StatefulWidget {
  final Article article;

  const ReadArticleScreen({required this.article});

  @override
  _ReadArticleScreenState createState () =>
      _ReadArticleScreenState();
}


class _ReadArticleScreenState extends State<ReadArticleScreen>{
  ScrollController _scrollController = ScrollController();
  Color backgroundColor = Colors.transparent;
  AppUtil _appUtil = AppUtil();
  double elevation = 0;

  @override
  void initState () {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      backgroundColor = Colors.white;
      elevation = 1;
    }

    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      backgroundColor = COLOR_GRAY;
      elevation = 0;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: TransparentAppBarWidget(
          elevation: elevation,
          backgroundColor: backgroundColor,
          onPressed: _confirmationModal,
          actions: [
            PopupMenuButton(
              onSelected: (selected) {
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'Saved',
                  child: TextButton.icon(onPressed: null, icon: Icon(Icons.save_alt), label: Text('Saved')),
                ),
                PopupMenuItem(
                  value: 'Like',
                  child: TextButton.icon(onPressed: null, icon: Icon(Icons.favorite_border), label: Text('Like')),
                ),
                PopupMenuItem(
                  value: 'Report',
                  child: TextButton.icon(onPressed: null, icon: Icon(Icons.report), label: Text('Report')),
                ),
              ],
            )

          ],
      ),
      body: SizedBox(
        width: SizeConfig.screenWidth!,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _articleTitleSection(context),
              _iconSection(context),
              SizedBox(height: 20),
              _articleHeroImage(context),
              _articleParagraph(context),
              BlocBuilder<AdsBloc, AdsState>(
                builder: (context, state) {
                  Ads ads = state.ads;
                  return Column(
                    children: [
                      AdsWidget(ads: ads),
                      _bannerAds(context, ads),
                    ],
                  );
                },
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: COLOR_PURPLE,
                    padding: EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => ClaimRewardWidget(
                        onPressed: () {
                          Navigator.pushNamed(context, quiz_screen, arguments: widget.article);
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Claim Rewards",
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.white,
                    )
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _articleTitleSection(context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: "${widget.article.articleTitle!}\n",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "By ",
              style: TextStyle(height: 2),
              children: <TextSpan>[
                TextSpan(
                  text: "${widget.article.author} ",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: COLOR_PURPLE,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextSpan(
                  text: "published ${timeago.format(DateTime.parse(widget.article.date!))}\n",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            ...widget.article.tags!.map((tag) {
              return TextSpan(
                text: "${tag.name} ",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.blockSizeVertical! * 2,
                  height: 1.5,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _iconSection(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: FaIcon(
              FontAwesomeIcons.twitter,
            ),
          ),
          SizedBox(width: 5),
          InkWell(
            onTap: () {},
            child: Icon(Icons.facebook_outlined),
          ),
          SizedBox(width: 5),
          InkWell(
            onTap: () {},
            child: FaIcon(
              FontAwesomeIcons.linkedinIn,
            ),
          ),
          SizedBox(width: 5),
          InkWell(
              onTap: () {},
              child: Icon(
                  Icons.cloud_download
              )
          ),
        ],
      ),
    );
  }

  Widget _articleHeroImage(context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
        tag: widget.article.id!,
        child: CachedNetworkImage(
          imageUrl: '${dev_endpoint}/articles/articles-default.jpg',
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _articleParagraph(context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      width: SizeConfig.screenWidth!,
      child: Html(
        data: widget.article.articleContent!,
      ),
    );
  }

  Widget _bannerAds(context, Ads ads) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child:  CachedNetworkImage(
        imageUrl: '${dev_endpoint}/ads/images/footer/footer-ads-default.jpg',
        placeholder: (_, __) {
          return Placeholder();
        },
      ),
    );
  }


  void _confirmationModal () {
    _appUtil.confirmModal(
        context,
        title: "Continue Reading",
        message: "Would you like saved this article for later?",
        cancelBtn: true,
        onPressed: () {
          context.read<ArticlesBloc>().add(UnfinishedArticleRead(article: widget.article));
          Navigator.pop(context);
          Navigator.pop(context);
        }
    );
  }
}
