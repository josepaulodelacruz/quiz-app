import 'package:equatable/equatable.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/question.dart';

abstract class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

class CurrentReadArticle extends ArticleEvent {
  final Article article;

  const CurrentReadArticle({
    this.article = Article.empty,
  });

  @override
  List<Object> get props => [];
}

class ArticleGetEvent extends ArticleEvent {

  const ArticleGetEvent();

  @override
  List<Object> get props => [];
}

class ArticleGetContentEvent extends ArticleEvent {
  final int id;

  const ArticleGetContentEvent({this.id = 0});

  @override
  List<Object> get props => [id];
}

class ArticleSortByCategories extends ArticleEvent {
  final List<Tag> tags;


  const ArticleSortByCategories({
    this.tags = const [],
  });

  @override
  List<Object> get props => [tags];
}

class ArticleView extends ArticleEvent {
  final int userId;
  final int articleId;

  const ArticleView({
    this.userId = 0,
    this.articleId = 0,
  });

  Map<String, String> toMap() {
    return {
      'user_id': userId.toString(),
      'article_id': articleId.toString(),
    };
  }

  @override
  List<Object> get props => [userId, articleId];
}

class ArticleSave extends ArticleEvent {

  const ArticleSave();

  @override
  List<Object> get props => [];
}

class UnfinishedArticleRead extends ArticleEvent {
  final Article article;

  const UnfinishedArticleRead({
    required this.article,
  });

  @override
  List<Object> get props => [article];
}

class GetUnfinishedReadArticle extends ArticleEvent {
  const GetUnfinishedReadArticle();

  @override
  List<Object> get props => [];
}

class RemoveUnfinishedReadArticle extends ArticleEvent {
  final int? id;

  const RemoveUnfinishedReadArticle({this.id});

  @override
  List<Object> get props => [];
}

class SavedArticle extends ArticleEvent {
  final int? userId;
  final int? articleId;
  final Article article;

  const SavedArticle({this.userId, this.articleId, this.article = Article.empty});

  @override
  List<Object> get props => [];
}

class GetSavedArticles extends ArticleEvent {
  final int? userId;

  const GetSavedArticles({this.userId});

  @override
  List<Object> get props => [];
}

class DeletedSavedArticles extends ArticleEvent {
  final int? userId;
  final int? articleId;
  final Article? article;

  const DeletedSavedArticles({
    this.userId,
    this.articleId,
    this.article,
  });

  @override
  List<Object> get props => [];
}

class GetLikesArticle extends ArticleEvent {
  final int userId;

  const GetLikesArticle({this.userId = 0});

  @override
  List<Object> get props => [];
}

class LikeArticle extends ArticleEvent {
  final int? userId;
  final int? articleId;

  const LikeArticle({
    this.userId,
    this.articleId,
  });

  @override
  List<Object> get props => [];
}

class UnlikeArticle extends ArticleEvent {
  final int? userId;
  final int? articleId;

  const UnlikeArticle({
    this.userId,
    this.articleId,
  });

  @override
  List<Object> get props => [];
}

class GetQuizArticle extends ArticleEvent {
  final int? articleId;

  const GetQuizArticle({this.articleId});

  @override
  List<Object> get props => [];
}

class ScoreProcess extends ArticleEvent {
  final List<Map<String, dynamic>> result;
  final List<Question> questions;
  final int articleId;
  final int userId;

  const ScoreProcess({this.result = const [], this.questions = const [], this.articleId = 0, this.userId = 0});

  @override
  List<Object> get props => [result, questions, articleId, userId];

}


