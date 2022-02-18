import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:rte_app/blocs/tags/tag_bloc.dart';
import 'package:rte_app/main-dev.dart';
import 'package:rte_app/main.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/screens/payments/payment_method_screen.dart';
import 'package:rte_app/services/article_service.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';

class ArticlesBloc extends Bloc<ArticleEvent, ArticlesState> {
  final ArticleService articleService;

  ArticlesBloc({
    required this.articleService,
  }) : super(ArticlesState.unknown()) {
    on<CurrentReadArticle>(_currentRead);
    on<ArticleGetEvent>(_getArticles);
    on<ArticleView>(_viewArticle);
    on<ArticleSortByCategories>(_sortArticles);
    on<ArticleSave>(_savedUnfinishedReadArticle);
    on<UnfinishedArticleRead>(_unfinished);
    on<GetUnfinishedReadArticle>(_getUnfinishedReadArticles);
    on<RemoveUnfinishedReadArticle>(_removeUnfinishedReadArticle);
    on<SavedArticle>(_savedArticle);
    on<GetSavedArticles>(_getSavedArtlces);
    on<DeletedSavedArticles>(_deleteSavedArticles);
    on<GetLikesArticle>(_getLikesArticles);
    on<LikeArticle>(_likeArticle);
    on<UnlikeArticle>(_unlikeArticle);
  }

  _test(ArticleGetEvent event, Emitter<ArticlesState> emit) {
    print('testing article bloc');
  }

  _currentRead(CurrentReadArticle event, Emitter<ArticlesState> emit) async {
    emit(state.copyWith(currentRead: event.article));
  }

  _getArticles(ArticleGetEvent event, Emitter<ArticlesState> emit) async {
    var response = await articleService.getVerifiedArticles();
    emit(state.copyWith(status: ArticleStatus.loading));
    if (!response.error) {
      List<Article> articles = response.collections!.map((article) {
        return Article.fromMap(article);
      }).toList();
      emit(state.copyWith(
          articles: articles,
          sortedArticles: articles,
          status: ArticleStatus.success));
    } else {
      emit(state.copyWith(
          status: ArticleStatus.failed, message: response.message));
    }
  }

  _viewArticle(ArticleView event, Emitter<ArticlesState> emit) async {
    await articleService.viewArticle(event);
  }

  _sortArticles(
      ArticleSortByCategories event, Emitter<ArticlesState> emit) async {
    List<Article> articles = [];
    event.tags.map((tag) {
      state.articles.map((article) {
        article.tags!.map((t) {
          if (t.name == tag.name) {
            var a = articles
                .where((el) => el.articleTitle == article.articleTitle)
                .toList();
            if (a.isEmpty) {
              articles.add(article);
            }
          }
        }).toList();
      }).toList();
    }).toList();
    emit(state.copyWith(sortedArticles: articles, articles: state.articles));
  }

  _unfinished(UnfinishedArticleRead event, Emitter<ArticlesState> emit) async {
    emit(state.copyWith(
        unfinishedReadArticle: event.article, status: ArticleStatus.waiting));
  }

  _savedUnfinishedReadArticle(
      ArticleSave event, Emitter<ArticlesState> emit) async {
    var response = articleService.savedArticle(state.unfinishedReadArticle);
  }

  _getUnfinishedReadArticles(_, Emitter<ArticlesState> emit) async {
    List<Article> unfinishedArticles =
        await articleService.getSavedUnfinishedArticles();
    emit(state.copyWith(unfinishedReadArticles: unfinishedArticles));
  }

  _removeUnfinishedReadArticle(
      RemoveUnfinishedReadArticle event, Emitter<ArticlesState> emit) async {
    List<Article> articles =
        await articleService.removeSavedArticles(event.id!);
    emit(state.copyWith(
        unfinishedReadArticles: articles,
        unfinishedReadArticle: Article.empty));
  }

  _savedArticle(SavedArticle event, Emitter<ArticlesState> emit) async {
    var response = await articleService.userSavedArticle(event);
    emit(state.copyWith(status: ArticleStatus.loading));
    await Future.delayed(Duration(seconds: 2));
    if (!response.error) {
      List<Article> articles = state.getSavedArticles.toList();
      articles.add(event.article);
      emit(state.copyWith(
          status: ArticleStatus.success,
          message: response.message,
          getSavedArticles: articles,
          currentRead: state.currentRead.copyWith(isSaved: true),
      ));
    } else {
      emit(state.copyWith(
          status: ArticleStatus.failed));
    }
  }

  _getSavedArtlces(GetSavedArticles event, Emitter<ArticlesState> emit) async {
    var response = await articleService.getSavedArticles(event);
    emit(state.copyWith(status: ArticleStatus.loading));
    await Future.delayed(Duration(seconds: 2));
    if (!response.error) {
      List<Article> getSavedArticles = response.collections!.map((collection) {
        return Article.fromMap(collection['article']);
      }).toList();
      emit(state.copyWith(
          status: ArticleStatus.success, getSavedArticles: getSavedArticles));
    } else {
      emit(state.copyWith(
          status: ArticleStatus.failed, message: response.message));
    }
  }

  _deleteSavedArticles(
      DeletedSavedArticles event, Emitter<ArticlesState> emit) async {
    var response = await articleService.deleteSavedArticles(event);
    emit(state.copyWith(status: ArticleStatus.loading));
    if (!response.error) {
      List<Article> articles = state.getSavedArticles;
      articles.removeWhere((element) => element.id == event.articleId);
      emit(state.copyWith(
          getSavedArticles: articles,
          status: ArticleStatus.success));
    } else {
      emit(state.copyWith(
          status: ArticleStatus.waiting, message: response.message));
    }
  }

  _getLikesArticles(GetLikesArticle event, Emitter<ArticlesState> emit) async {
    var response = await articleService.getLikesOfArticle(event.userId);
    emit(state.copyWith(status: ArticleStatus.loading));
    if(!response.error) {
      List<Article> likesArticles = response.collections!.map((collection) {
        return Article.fromMap(collection['article']);
      }).toList();
      emit(state.copyWith(status: ArticleStatus.success, likesArticles: likesArticles));
    } else {
      emit(state.copyWith(status: ArticleStatus.failed, message: response.message));
    }
  }

  _likeArticle(LikeArticle event, Emitter<ArticlesState> emit) async {
    var response = await articleService.likingOfArticle(event);
    emit(state.copyWith(status: ArticleStatus.loading));
    await Future.delayed(Duration(seconds: 1));
    if(!response.error) {

      emit(state.copyWith(status: ArticleStatus.success, message: response.message, currentRead: state.currentRead.copyWith(isLike: true)));
    } else {
      emit(state.copyWith(status: ArticleStatus.failed, message: response.message));
    }
  }

  _unlikeArticle(UnlikeArticle event, Emitter<ArticlesState> emit) async {
    var response = await articleService.unlikingOfArticle(event);
    emit(state.copyWith(status: ArticleStatus.loading));
    await Future.delayed(Duration(seconds: 1));
    if(!response.error) {
      emit(state.copyWith(status: ArticleStatus.success, currentRead: state.currentRead.copyWith(isLike: false)));
    } else {
      emit(state.copyWith(status: ArticleStatus.failed));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
