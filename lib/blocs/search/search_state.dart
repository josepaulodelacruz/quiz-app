

import 'package:equatable/equatable.dart';

enum SearchStatus {
  waiting,
  loading,
  success,
  failed,
}

class SearchState extends Equatable {
  final Map<String, dynamic> queries;
  final SearchStatus status;

  const SearchState._({
    this.queries = const {},
    this.status = SearchStatus.waiting,
  });

  const SearchState.unknown() : this._();

  SearchState copyWith({
    Map<String, dynamic>? queries,
    SearchStatus? status,
  }) {
    return SearchState._(
      queries: queries ?? this.queries,
      status: status ?? this.status,
    );

  }

  @override
  List<Object> get props => [queries, status];

}