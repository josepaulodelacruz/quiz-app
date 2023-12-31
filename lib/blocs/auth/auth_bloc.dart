

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:rte_app/blocs/auth/auth_event.dart';
import 'package:rte_app/blocs/auth/auth_state.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:rte_app/blocs/cookie/cookie_event.dart';
import 'package:rte_app/blocs/cookie/cookie_state.dart';
import 'package:rte_app/main.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/user.dart';
import 'package:rte_app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService? authService;
  CookieBloc? cookieBloc;

  AuthBloc({
    this.authService,
  }) : super(const AuthState.unknown()) {
    on<AuthLogin>(_onLogin);
    on<AuthRegister>(_onRegister);
    on<AuthLogout>(_onLogout);
    on<AuthUpdateUser>(_updateUser);
    on<AuthPersistUser>(_persistUser);
    on<AuthViewUser>(_authViewedUser);
    on<AuthViewAuthor>(_authViewedAuthor);
  }

  void _persistUser(AuthPersistUser event, Emitter<AuthState> emit) {
    var userDecode = jsonDecode(event.user);
    User user = User.fromMap(userDecode);
    emit(state.copyWith(user: user));
  }

  void _onLogin(
      AuthLogin event,
      Emitter<AuthState> emit
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookieBloc = getIt<CookieBloc>();
    emit(state.copyWith(status: AuthStatus.loading));
    AuthResponse response = await authService!.login(event);
    await Future.delayed(Duration(seconds: 1));
    if(response.error == false) {
      User user = User.fromMap({...response.collections!});
      var userEncode = jsonEncode(user.toMap());
      prefs.setString('user-details', userEncode);
      emit(state.copyWith(status: AuthStatus.success, user: user));
      cookieBloc.add(CookieStore(cookie: response.token));
      print('saving token ${response.token}');
    } else {
      emit(state.copyWith(status: AuthStatus.failed, message: response.message));
    }
  }

  void _onRegister(
      AuthRegister event,
      Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    var response = await authService!.register(event);
    await Future.delayed(Duration(seconds: 1));
    if(response.error == false) {
      User user = User.fromMap(response.collections!);
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } else {
      emit(state.copyWith(status: AuthStatus.failed, message: response.message));
    }
  }

  void _updateUser (AuthUpdateUser event, Emitter<AuthState> emit) async {
    var response = await authService!.updateUser(event, state.user);
    emit(state.copyWith(status: AuthStatus.loading));
    if(!response.error!) {
      emit(state.copyWith(status: AuthStatus.success, message: response.message));
    } else {
      emit(state.copyWith(status: AuthStatus.failed, message: response.message));
    }
  }

  void _authViewedUser(AuthViewUser event, Emitter<AuthState> emit) async {
    var response = await authService!.viewedUser(event.userId);
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(Duration(seconds: 1));
    if(!response.error!) {
      User user = User.fromMap(response.collections!['user']);
      List<Article> savedArticles = [];
      response.collections!['saved_articles'].map((article) {
        savedArticles.add(Article.fromMap(article['article']));
      }).toList();
      emit(state.copyWith(status: AuthStatus.viewUser, viewedUser: user, viewedSavedArticles: savedArticles));
    } else {
      emit(state.copyWith(status: AuthStatus.failed, message: response.message));
    }
    emit(state.copyWith(status: AuthStatus.waiting));
  }

  void _authViewedAuthor(AuthViewAuthor event, Emitter<AuthState> emit) async {
    var response = await authService!.viewedAuthor(event.authorId);
    emit(state.copyWith(status: AuthStatus.loading));
    if(!response.error!) {
      User user = User.fromMap(response.collections!['author']);
      List<Article> articles = [];
      response.collections!['articles'].map((article) {
        articles.add(Article.fromMap(article));
      }).toList();
      user.articles = articles;
      emit(state.copyWith(viewedAuthor: user, status: AuthStatus.viewAuthor));
    } else {
      emit(state.copyWith(status: AuthStatus.failed));
    }
    emit(state.copyWith(status: AuthStatus.waiting));
  }

  void _onLogout (
      AuthLogout event,
      Emitter<AuthState> emit
      ) async {
    var response = await authService!.logout();
  }

  @override
  Future<void> close () {
    return super.close();
  }
}
