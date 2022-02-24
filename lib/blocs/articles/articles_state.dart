

import 'package:equatable/equatable.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/question.dart';

enum ArticleStatus {
  waiting,
  loading,
  success,
  failed,
}

class ArticlesState extends Equatable {
  final List<Article> articles;
  final List<Article> sortedArticles;
  final Article unfinishedReadArticle;
  final Article currentRead;
  final List<Article> unfinishedReadArticles;
  final List<Article> getSavedArticles;
  final List<Article> likesArticles;
  final List<Question> questions;
  final ArticleStatus status;
  final String articleContent;
  final String message;
  final String title;

  const ArticlesState._({
    this.articles = const [],
    this.sortedArticles = const [],
    this.currentRead = Article.empty,
    this.unfinishedReadArticle = Article.empty,
    this.unfinishedReadArticles = const [],
    this.getSavedArticles = const [],
    this.likesArticles = const [],
    this.questions = const [],
    this.status = ArticleStatus.waiting,
    this.articleContent = "",
    this.message = "",
    this.title = "",
  });

  const ArticlesState.unknown() : this._();

  ArticlesState copyWith({
    List<Article>? articles,
    List<Article>? sortedArticles,
    Article? currentRead,
    Article? unfinishedReadArticle,
    List<Article>? unfinishedReadArticles,
    List<Article>? getSavedArticles,
    List<Article>? likesArticles,
    List<Question>? questions,
    ArticleStatus? status,
    String? articleContent,
    String? message,
    String? title,
  }) {
    return ArticlesState._(
      articles: articles ?? this.articles,
      sortedArticles: sortedArticles ?? this.sortedArticles,
      currentRead: currentRead ?? this.currentRead,
      unfinishedReadArticle: unfinishedReadArticle ?? this.unfinishedReadArticle,
      unfinishedReadArticles: unfinishedReadArticles ?? this.unfinishedReadArticles,
      getSavedArticles: getSavedArticles ?? this.getSavedArticles,
      likesArticles: likesArticles ?? this.likesArticles,
      questions: questions ?? this.questions,
      status: status ?? this.status,
      articleContent: articleContent ?? this.articleContent,
      message: message ?? this.message,
      title: title ?? this.title,
    );
  }

  @override
  List<Object> get props => [articles, sortedArticles, currentRead, unfinishedReadArticle, unfinishedReadArticles, getSavedArticles, likesArticles, articleContent, status, message, title];

}
