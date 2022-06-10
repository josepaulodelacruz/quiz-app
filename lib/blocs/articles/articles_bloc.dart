import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:rte_app/blocs/tags/tag_bloc.dart';
import 'package:rte_app/main-dev.dart';
import 'package:rte_app/main.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/pagination.dart';
import 'package:rte_app/models/question.dart';
import 'package:rte_app/models/violation.dart';
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
    on<VerifiedArticlesNextScroll>(_verifiedNextPage);
    on<ShowViolationList>(_showViolation);
    on<GetViolations>(_getViolations);
    on<ReportArticle>(_reportArticle);
    on<ArticleGetContentEvent>(_articleGetContent);
    on<ArticleView>(_viewArticle);
    on<GetArticleById>(_getArticleById);
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
    on<GetQuizArticle>(_getQuizArticle);
    on<ScoreProcess>(_scoreProcess);
  }

  _test(ArticleGetEvent event, Emitter<ArticlesState> emit) {
    print('testing article bloc');
  }

  _currentRead(CurrentReadArticle event, Emitter<ArticlesState> emit) async {
    emit(state.copyWith(currentRead: event.article));
  }

  _showViolation (ShowViolationList event, Emitter<ArticlesState> emit) async {
    if(event.isShow) {
      emit(state.copyWith(status: ArticleStatus.showViolationList));
    } else {
      emit(state.copyWith(status: ArticleStatus.waiting));
    }
  }

  _getViolations (GetViolations event, Emitter<ArticlesState> emit) async {
    var response = await articleService.getViolations();
    emit(state.copyWith(status: ArticleStatus.loading));
    if(!response.error) {
      List<Violation> violations = [];
      response.collections!['violations'].map((violation) {
        violations.add(Violation.fromMap(violation));
      }).toList();
      emit(state.copyWith(violations: violations, status: ArticleStatus.success, title: ""));
    } else {
      emit(state.copyWith(status: ArticleStatus.success, title: "Something went wrong"));
    }
  }

  _reportArticle(ReportArticle event, Emitter<ArticlesState> emit) async {

    emit(state.copyWith(status: ArticleStatus.loading));
    var response = await articleService.reportArticle(event);
    if(!response.error) {
      if(event.hide) {
        emit(state.copyWith(status: ArticleStatus.hideArticle, title: ""));
      }
      int index = state.articles.indexWhere((element) => element.id == event.id);
      int savedArticleIndex = state.getSavedArticles.indexWhere((element) => element.id == event.id);
      state.articles.removeAt(index);
      if(savedArticleIndex != -1) {
        state.getSavedArticles.removeAt(savedArticleIndex);
      }
      emit(state.copyWith(articles: state.articles, getSavedArticles: state.getSavedArticles, status: ArticleStatus.success, title: ""));
    } else {
      emit(state.copyWith(status: ArticleStatus.failed, message: response.message));
    }
    emit(state.copyWith(status: ArticleStatus.waiting));
  }

  _getArticles(ArticleGetEvent event, Emitter<ArticlesState> emit) async {
    List<Article> articles = [];
    List<Article> trendingArticles = [];
    List<Article> latestArticle = [];
    var response = await articleService.getVerifiedArticles();
    emit(state.copyWith(status: ArticleStatus.loading));
    if (!response.error) {

      VerifiedArticlePagination verifiedArticlePagination = VerifiedArticlePagination.fromMap(response.collections!['verified_articles']);

      response.collections!['verified_articles']['data'].map((article) {
        articles.add(Article.fromMap(article));
      }).toList();

      response.collections!['trending_articles'].map((article) {
         trendingArticles.add(Article.fromMap(article));
      }).toList();

      response.collections!['latest_articles'].map((article) {
        latestArticle.add(Article.fromMap(article));
      }).toList();

      emit(state.copyWith(
          articles: articles,
          sortedArticles: articles,
          trendingArticles: trendingArticles,
          latestArticles: latestArticle,
          status: ArticleStatus.success,
          verifiedArticlePagination: verifiedArticlePagination,
      ));
    } else {
      emit(state.copyWith(
          status: ArticleStatus.failed, message: response.message));
    }
  }

  _verifiedNextPage (VerifiedArticlesNextScroll event, Emitter<ArticlesState> emit) async {
    if(event.verifiedArticlePagination.urlNextPage.isEmpty) return;
    var a = event.verifiedArticlePagination.urlNextPage.split('?');
    String cursor = a[1];
    var response = await articleService.getNextArticles(cursor);
    if(!response.error) {
      List<Article> nextArticles = [];
      List<Article> articles = [];
      VerifiedArticlePagination paginate = VerifiedArticlePagination.fromMap(response.collections!['body']);
      response.collections!['body']['data'].map((article) {
        nextArticles.add(Article.fromMap(article));
      }).toList();
      articles = [...state.articles, ...nextArticles];
      emit(state.copyWith(verifiedArticlePagination: paginate, articles: articles));
    }
  }

  _viewArticle(ArticleView event, Emitter<ArticlesState> emit) async {
    await articleService.viewArticle(event);
  }

  _getArticleById(GetArticleById event, Emitter<ArticlesState> emit) async {
    var response = await articleService.getArticleById(event.articleId);
    emit(state.copyWith(status: ArticleStatus.loading));
    if(!response.error) {
      Article article = Article.fromMap(response.collections![0]);
      emit(state.copyWith(status: ArticleStatus.success, title: "", currentRead: article));
    } else {
      emit(state.copyWith(status: ArticleStatus.failed));
    }
  }

  _articleGetContent (ArticleGetContentEvent event, Emitter<ArticlesState> emit) async {
    var response = await articleService.articleGetContent(event);
    emit(state.copyWith(status: ArticleStatus.loading));
    if(!response.error) {
      emit(state.copyWith(status: ArticleStatus.success, title: "", articleContent: response.collections!['article_content']));
    } else {
      emit(state.copyWith(status: ArticleStatus.loading, title: ""));
    }
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
    if(state.unfinishedReadArticle.articleTitle != null) {
       var response = articleService.savedArticle(state.unfinishedReadArticle);
       print('saving article ${response}');
    }
  }

  _getUnfinishedReadArticles(_, Emitter<ArticlesState> emit) async {
    List<Article> unfinishedArticles =
        await articleService.getSavedUnfinishedArticles();
    emit(state.copyWith(unfinishedReadArticles: unfinishedArticles, unfinishedReadArticle: Article.empty, title: "", message: ""));
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
      List<Article> savedArticles= state.getSavedArticles.toList();
      savedArticles.add(event.article);
      int index = state.articles.indexWhere((el) => el.id == event.article.id);
      state.articles[index] = event.article;
      emit(state.copyWith(
          status: ArticleStatus.success,
          title: "Successfully Saved article!",
          message: response.message,
          articles: state.articles,
          getSavedArticles: savedArticles,
          currentRead: event.article,
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
      List<Article> getSavedArticles = [];
      response.collections!['body'].map((collection) {
        getSavedArticles.add(Article.fromMap(collection['article']));
      }).toList();
      if(!event.isViewSavedArticles) {
        emit(state.copyWith(
            status: ArticleStatus.owner, getSavedArticles: getSavedArticles, message: response.message, title: ""));
      } else {
        emit(state.copyWith(
            status: ArticleStatus.viewUserSavedArticle, getUserSavedArticles: getSavedArticles, message: response.message, title: ""));
      }
    } else {
      emit(state.copyWith(
          status: ArticleStatus.failed, message: response.message, title: "Failed to saved article"));
    }
  }

  _deleteSavedArticles(
      DeletedSavedArticles event, Emitter<ArticlesState> emit) async {
    var response = await articleService.deleteSavedArticles(event);
    emit(state.copyWith(status: ArticleStatus.loading));
    if (!response.error) {
      List<Article> getSavedArticles = state.getSavedArticles;
      getSavedArticles.removeWhere((element) => element.id == event.articleId);
      int index = state.articles.indexWhere((element) => element.id == event.articleId);
      state.articles[index] = event.article;
      emit(state.copyWith(
          articles: state.articles,
          getSavedArticles: getSavedArticles,
          currentRead: event.article,
          status: ArticleStatus.success, title: "", message: ""));
    } else {
      emit(state.copyWith(
          status: ArticleStatus.waiting, message: "Something went wrong, Please try again later.", title: "Failed to unlike"));
    }
  }

  _getLikesArticles(GetLikesArticle event, Emitter<ArticlesState> emit) async {
    var response = await articleService.getLikesOfArticle();
    emit(state.copyWith(status: ArticleStatus.loading));
    if(!response.error) {
      List<Article> likesArticles = (response.collections!['body'] as List).map((collection) {
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
    if(!response.error) {
      int index = state.articles.indexWhere((element) => element.id == event.articleId);
      state.articles[index] = event.article;
      emit(state.copyWith(articles: state.articles, status: ArticleStatus.success, title: "", message: response.message, currentRead: event.article));
    } else {
      emit(state.copyWith(status: ArticleStatus.failed, title: "Failed to like article", message: response.message));
    }
  }

  _unlikeArticle(UnlikeArticle event, Emitter<ArticlesState> emit) async {
    var response = await articleService.unlikingOfArticle(event);
    emit(state.copyWith(status: ArticleStatus.loading));
    await Future.delayed(Duration(seconds: 1));
    if(!response.error) {
      emit(state.copyWith(status: ArticleStatus.success, title: "", currentRead: state.currentRead.copyWith(isLike: false)));
    } else {
      emit(state.copyWith(status: ArticleStatus.failed, title: ""));
    }
  }

  _getQuizArticle (GetQuizArticle event, Emitter<ArticlesState> emit) async {
    var response = await articleService.getQuestions(event);
    emit(state.copyWith(status: ArticleStatus.loading));
    if(!response.error) {
      List<Question> questions = [];
      response.collections!['body'].map((question) {
        return questions.add(Question.fromMap(question));
      }).toList();
      emit(state.copyWith(status: ArticleStatus.success, title: "Question fetched!", message: response.message, questions: questions));
    } else {
      emit(state.copyWith(status: ArticleStatus.failed, title: ""));
    }
    emit(state.copyWith(status: ArticleStatus.waiting));
  }

  _scoreProcess (ScoreProcess event, Emitter<ArticlesState> emit) async {
    int scores = 0;
    List<Map<String, dynamic>> body = [];
    List<Map<String, dynamic>> results = List.generate(event.questions.length, (index) => {});
    emit(state.copyWith(status: ArticleStatus.loading));
    event.questions.map((question) {
      int index = event.questions.indexOf(question);
      question.answers!.map((answer) {
        if(answer.isCorrect!) {
          if(answer.answer == event.result[index]['answer']) {
            results[index] = {
              'question_id': question.id.toString(),
              'answer_id': answer.id.toString(),
              'is_correctly_answered': 1,
            };
            scores += 1;
          }
        }

        if(results[index].isEmpty) {
          results[index] = {
            'question_id': question.id.toString(),
            'answer_id': answer.id.toString(),
            'is_correctly_answered': 0,
          };
        }
      }).toList();
    }).toList();

    double percentage = scores  / event.questions.length * 100;

    Map<String, dynamic> content = {
      'details': {
        'user_id': event.userId.toString(),
        'article_id': event.articleId.toString(),
        'score': scores.toString(),
        'percentage': percentage.toString(),
      },
    };
    Map<String, dynamic> _results = {
      'results': results,
    };
    body.add(content);
    body.add(_results);

    var response = await articleService.scoreResult(body);
    if(!response.error) {
      emit(state.copyWith(status: ArticleStatus.success, title: "", overall: body));
    } else {
      emit(state.copyWith(status: ArticleStatus.success, title: "Something went wrong!", message: "Please try again later"));
    }

    emit(state.copyWith(status: ArticleStatus.waiting));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
