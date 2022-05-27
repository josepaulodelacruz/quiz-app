
import 'package:rte_app/models/article.dart';

class ScreenArguments {
  final Article article;
  final bool isViewedSavedArticle;
  final List<Article> categorizedArticles;
  final String pageName;

  const ScreenArguments({
    this.article = Article.empty,
    this.isViewedSavedArticle = false,
    this.pageName = "",
    this.categorizedArticles = const [],
  });
}