import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/widgets/book_widget.dart';
import 'package:rte_app/models/article.dart';

class ContinueReadingSection extends StatefulWidget {
  List<Article> unfinishedReadArticles;

  ContinueReadingSection({Key? key, required this.unfinishedReadArticles}) : super(key: key);

  @override
  _ContinueReadingSectionState createState() => _ContinueReadingSectionState();
}

class _ContinueReadingSectionState extends State<ContinueReadingSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 5, bottom: 20),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Continue Reading",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.w600
              )
            ),
          ),
        ),
        if(widget.unfinishedReadArticles.length > 0) ...[
          CarouselSlider.builder(
            itemCount: widget.unfinishedReadArticles.length,
            options: CarouselOptions(
              aspectRatio: 1.6,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              enableInfiniteScroll: false,
              // autoPlay: true,
            ),
            itemBuilder: (context, itemIndex, realIndex) {
              return BookWidget(article: widget.unfinishedReadArticles[itemIndex], continueReading: true);
            },
          ),
        ]
      ],
    );
  }
}
