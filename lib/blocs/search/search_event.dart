
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {

  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryEvent extends SearchEvent {
  const SearchQueryEvent({this.query = ""});

  final String query;

  @override
  List<Object> get props => [];
}