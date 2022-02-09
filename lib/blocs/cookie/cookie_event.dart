

import 'package:equatable/equatable.dart';

abstract class CookieEvent extends Equatable {
  const CookieEvent();

  @override
  List<Object> get props => [];
}

class CookieStore extends CookieEvent {
  final String? cookie;

  const CookieStore({this.cookie});

  @override
  List<Object> get props => [];
}