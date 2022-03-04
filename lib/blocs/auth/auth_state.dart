
import 'package:equatable/equatable.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/user.dart';

enum AuthStatus {
  waiting,
  loading,
  success,
  failed,
}

class AuthState extends Equatable {
  final String test;
  final AuthStatus status;
  final User? user;
  final User? viewedUser;
  final User? viewedAuthor;
  final List<Article> viewedSavedArticles;
  final List<Article> viewedArticles;
  final String message;

  const AuthState._({
    this.test = "",
    this.status = AuthStatus.waiting,
    this.user,
    this.viewedUser,
    this.viewedAuthor,
    this.viewedSavedArticles = const [],
    this.viewedArticles = const [],
    this.message = "",
  });

  const AuthState.unknown() : this._();

  AuthState copyWith({
    String? test,
    AuthStatus? status,
    User? user,
    User? viewedUser,
    User? viewedAuthor,
    List<Article>? viewedSavedArticles,
    List<Article>? viewedArticles,
    String? message,
  }) {
    return AuthState._(
      test: test ?? this.test,
      status: status ?? this.status,
      user: user ?? this.user,
      viewedUser: viewedUser ?? this.viewedUser,
      viewedAuthor: viewedAuthor ?? this.viewedAuthor,
      viewedSavedArticles: viewedSavedArticles ?? this.viewedSavedArticles,
      viewedArticles: viewedArticles ?? this.viewedArticles,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [test, status, viewedSavedArticles, viewedArticles];
}
