
import 'package:equatable/equatable.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:rte_app/models/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthUpdateUser extends AuthEvent {
  const AuthUpdateUser({
    this.fullName = "",
    this.email = "",
  });
  final String fullName;
  final String email;
  @override
  List<Object> get props => [fullName, email];
}

class AuthPersistUser extends AuthEvent {
  final String user;

  const AuthPersistUser({this.user = ""});

  @override
  List<Object> get props => [user];
}

class AuthLogin extends AuthEvent {
  const AuthLogin({
    required this.email,
    required this.password
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class AuthRegister extends AuthEvent {
  const AuthRegister({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
    this.middleName = "",
  });

  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;
  final String middleName;

  @override
  List<Object> get props => [email, password, confirmPassword, firstName, lastName, middleName];

  @override
  String toString() {
    return [email, password, confirmPassword, firstName, lastName, middleName].toString();
  }
}

class AuthLogout extends AuthEvent {
  const AuthLogout();

  @override
  List<Object> get props => [];
}

class AuthViewUser extends AuthEvent {
  final int userId;
  const AuthViewUser({this.userId = 0});

  @override
  List<Object> get props => [userId];
}

class AuthViewAuthor extends AuthEvent {
  final int authorId;
  final ArticlesBloc? bloc;
  final ArticleStatus? status;

  const AuthViewAuthor({this.authorId = 0, this.bloc, this.status});

  @override
  List<Object> get props => [authorId];
}