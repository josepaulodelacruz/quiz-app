

import 'package:equatable/equatable.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/question.dart';
import 'package:rte_app/models/violation.dart';

enum ArticleStatus {
  waiting,
  loading,
  success,
  owner,
  viewUserSavedArticle,
  viewAuthorArticle,
  showViolationList,
  failed,
  hideArticle,
}

class ArticlesState extends Equatable {
  final List<Violation> violations;
  final List<Article> articles;
  final List<Article> sortedArticles;
  final List<Article> trendingArticles;
  final List<Article> latestArticles;
  final Article unfinishedReadArticle;
  final Article currentRead;
  final List<Article> unfinishedReadArticles;
  final List<Article> getSavedArticles;
  final List<Article> getUserSavedArticles;
  final List<Article> likesArticles;
  final List<Question> questions;
  final ArticleStatus status;
  final List<Map<String, dynamic>> overall;
  final String articleContent;
  final String message;
  final String title;

  const ArticlesState._({
    this.violations = const [],
    this.articles = const [],
    this.sortedArticles = const [],
    this.trendingArticles = const [],
    this.latestArticles = const [],
    this.currentRead = Article.empty,
    this.unfinishedReadArticle = Article.empty,
    this.unfinishedReadArticles = const [],
    this.getSavedArticles = const [],
    this.getUserSavedArticles = const [],
    this.likesArticles = const [],
    this.questions = const [],
    this.overall = const [],
    this.status = ArticleStatus.waiting,
    this.articleContent = "",
    this.message = "",
    this.title = "",
  });

  const ArticlesState.unknown() : this._();

  ArticlesState copyWith({
    List<Violation>? violations,
    List<Article>? articles,
    List<Article>? sortedArticles,
    List<Article>? trendingArticles,
    List<Article>? latestArticles,
    Article? currentRead,
    Article? unfinishedReadArticle,
    List<Article>? unfinishedReadArticles,
    List<Article>? getSavedArticles,
    List<Article>? getUserSavedArticles,
    List<Article>? likesArticles,
    List<Question>? questions,
    List<Map<String, dynamic>>? overall,
    ArticleStatus? status,
    String? articleContent,
    String? message,
    String? title,
  }) {
    return ArticlesState._(
      violations: violations ?? this.violations,
      articles: articles ?? this.articles,
      sortedArticles: sortedArticles ?? this.sortedArticles,
      trendingArticles: trendingArticles ?? this.trendingArticles,
      latestArticles: latestArticles ?? this.latestArticles,
      currentRead: currentRead ?? this.currentRead,
      unfinishedReadArticle: unfinishedReadArticle ?? this.unfinishedReadArticle,
      unfinishedReadArticles: unfinishedReadArticles ?? this.unfinishedReadArticles,
      getSavedArticles: getSavedArticles ?? this.getSavedArticles,
      getUserSavedArticles: getUserSavedArticles ?? this.getUserSavedArticles,
      likesArticles: likesArticles ?? this.likesArticles,
      questions: questions ?? this.questions,
      overall: overall ?? this.overall,
      status: status ?? this.status,
      articleContent: articleContent ?? this.articleContent,
      message: message ?? this.message,
      title: title ?? this.title,
    );
  }

  @override
  List<Object> get props => [violations, articles, sortedArticles, trendingArticles, latestArticles, currentRead, unfinishedReadArticle, unfinishedReadArticles, getSavedArticles, getUserSavedArticles, likesArticles, overall, articleContent, status, message, title];

}
