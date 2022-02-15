
import 'package:rte_app/models/article.dart';

class ScreenArguments {
  final Article article;
  final bool isViewedSavedArticle;

  const ScreenArguments({
    this.article = Article.empty,
    this.isViewedSavedArticle = false,
  });
}