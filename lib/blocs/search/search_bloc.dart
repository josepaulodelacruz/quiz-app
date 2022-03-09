import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/search/search_event.dart';
import 'package:rte_app/blocs/search/search_state.dart';
import 'package:rte_app/services/search_service.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchService searchService;


  SearchBloc({required this.searchService}) : super(SearchState.unknown()) {
    on<SearchQueryEvent>(_searchQuery);
  }

  _searchQuery (SearchQueryEvent event, Emitter<SearchState> emit) async {
    var response = await searchService.search(event.query);
    emit(state.copyWith(queries: response.collections, status: SearchStatus.loading));
    await Future.delayed(Duration(seconds: 1));
    if(!response.error) {
      emit(state.copyWith(queries: response.collections, status: SearchStatus.success));
    } else {
      emit(state.copyWith(queries: {}, status: SearchStatus.failed));
    }
  }

}