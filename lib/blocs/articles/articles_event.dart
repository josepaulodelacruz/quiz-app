import 'package:equatable/equatable.dart';
import 'package:rte_app/models/article.dart';

abstract class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

class ArticleGetEvent extends ArticleEvent {

  const ArticleGetEvent();

  @override
  List<Object> get props => [];
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

  const SavedArticle({this.userId, this.articleId});

  @override
  List<Object> get props => [];
}

