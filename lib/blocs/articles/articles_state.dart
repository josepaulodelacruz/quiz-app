

import 'package:equatable/equatable.dart';
import 'package:rte_app/models/article.dart';

enum ArticleStatus {
  waiting,
  loading,
  success,
  failed,
}

class ArticlesState {
  final List<Article> articles;
  final List<Article> sortedArticles;
  final Article unfinishedReadArticle;
  final List<Article> unfinishedReadArticles;
  final ArticleStatus status;
  final String message;

  const ArticlesState._({
    this.articles = const [],
    this.sortedArticles = const [],
    this.unfinishedReadArticle = Article.empty,
    this.unfinishedReadArticles = const [],
    this.status = ArticleStatus.waiting,
    this.message = "",
  });

  const ArticlesState.unknown() : this._();

  ArticlesState copyWith({
    List<Article>? articles,
    List<Article>? sortedArticles,
    Article? unfinishedReadArticle,
    List<Article>? unfinishedReadArticles,
    ArticleStatus? status,
    String? message,
  }) {
    return ArticlesState._(
      articles: articles ?? this.articles,
      sortedArticles: sortedArticles ?? this.sortedArticles,
      unfinishedReadArticle: unfinishedReadArticle ?? this.unfinishedReadArticle,
      unfinishedReadArticles: unfinishedReadArticles ?? this.unfinishedReadArticles,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

}
