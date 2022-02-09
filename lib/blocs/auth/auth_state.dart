
import 'package:equatable/equatable.dart';
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
  final String message;

  const AuthState._({
    this.test = "",
    this.status = AuthStatus.waiting,
    this.user,
    this.message = "",
  });

  const AuthState.unknown() : this._();

  AuthState copyWith({
    String? test,
    AuthStatus? status,
    User? user,
    String? message,
  }) {
    return AuthState._(
      test: test ?? this.test,
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [test, status];
}
