import 'dart:async';

import 'package:localstore/localstore.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:rte_app/common/errors.dart';
import 'package:rte_app/main.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/services/api_service.dart';
import 'package:rte_app/common/constants.dart';

class ArticleResponse {
  String? message;
  int? status;
  List<dynamic>? collections;
  bool error;

  ArticleResponse({
    this.message,
    this.status,
    this.collections,
    this.error = false,
  });

  factory ArticleResponse.fromMap(Map<String, dynamic> map) {
    var model = ArticleResponse();
    if(map.containsKey('status') && map['status'] == 200) {
      model.message = map['message'];
      model.status = map['status'];
      model.collections = map['body'];
      model.error = false;
      return model;
    }
    model.message = map['message'];
    model.status = 400;
    model.error = true;
    return model;
  }

}


class ArticleService extends ApiService {
  final db = Localstore.instance;

  ArticleService ({String? token}) :
      super(endpoint: dev_endpoint, token: token);

  Future<ArticleResponse> getVerifiedArticles () async {
    try {
      var token = getIt<CookieBloc>().state.cookie!.session;
      var response = await get('/api/user/get-articles', token.toString());
      return ArticleResponse.fromMap(response);
    } on ApiResponseError catch (error) {
      return ArticleResponse(
        message: error.message,
        status: 400,
        error: true,
      );
    } catch (error) {
      return ArticleResponse(message: error.toString(), error: true);
    }
  }

  Future<ArticleResponse> viewArticle(ArticleView details) async {
    try {
      var token = getIt<CookieBloc>().state.cookie!.session;
      var response = await post('/api/user/article-view-count', {
        'user_id': details.userId.toString(),
        'article_id': details.articleId.toString(),
      });
      return ArticleResponse.fromMap(response);
    } on ApiResponseError catch (error) {
      return ArticleResponse(
        message: error.message,
        status: 400,
        error: true,
      );
    } catch (error) {
      return ArticleResponse(message: error.toString(), error: true);
    }
  }

  Future<void> savedArticle (Article article) async {
    List<Article> articles = await getSavedUnfinishedArticles();
    var alreadyExist = articles.where((el) => el.articleTitle == article.articleTitle).toList();
    if(alreadyExist == null || alreadyExist == [] || alreadyExist.isEmpty) {
      db.collection('unfinished_articles').doc(article.id.toString()).set(article.toMap());
    }
  }

  Future<List<Article>> getSavedUnfinishedArticles () async {
    final items = await db.collection('unfinished_articles').get();
    List<Article> articles = [];
    if(items == null) return articles;
    items.forEach((key, value) {
      Article article = Article.fromMap(value);
      articles.add(article);
    });
    return articles;
  }

  Future<List<Article>> removeSavedArticles (int? id) async {
    db.collection('unfinished_articles').doc(id.toString()).delete();
    List<Article> articles = await getSavedUnfinishedArticles();
    return articles;
  }

  Future<ArticleResponse> userSavedArticle(SavedArticle event) async {
    try {
      var response = await post('/api/user/save-article', {
        'user_id': event.userId.toString(),
        'article_id': event.articleId.toString(),
      });
      return ArticleResponse.fromMap(response);
    } on ApiResponseError catch(error) {
      return ArticleResponse(
        message: error.message,
        status: 400,
        error: true,
      );
    } catch (error) {
      return ArticleResponse(
        message: error.toString(),
        status: 400,
        error: true,
      );
    }
  }

}