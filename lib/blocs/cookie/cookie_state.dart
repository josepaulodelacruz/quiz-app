

import 'package:equatable/equatable.dart';
import 'package:rte_app/models/cookie.dart';

enum CookieStatus {
  expired,
  notExpired,
  unknown,
}

class CookieState extends Equatable {
  final Cookie? cookie;
  final CookieStatus status;

  const CookieState._({
    this.cookie,
    this.status = CookieStatus.unknown,
  });

  const CookieState.unknown() : this._();

  CookieState copyWith({
      Cookie? cookie,
      CookieStatus? status
  }) {
    return CookieState._(
      cookie: cookie ?? this.cookie,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}