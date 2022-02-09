import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/tags/tag_event.dart';
import 'package:rte_app/blocs/tags/tag_state.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/services/tag_service.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/main.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  final ArticlesBloc articlesBloc;
  TagService tagService;

  TagBloc({required this.tagService, required this.articlesBloc}) : super(TagState.unknown()) {
    on<GetTags>(_getTags);
    on<FilterTags>(_filterTags);
  }

  _getTags (GetTags event, Emitter<TagState> emit) async {
    var response = await tagService.getTags();
    emit(state.copyWith(status: TagStatus.loading));
    await Future.delayed(Duration(seconds: 2));
    if(!response.error!) {
      List<Tag> tags = response.collections!.map((tag) {
        return Tag.fromMap(tag);
      }).toList();
      emit(state.copyWith(tags: tags, selectedTags: [tags[0], tags[1]], status: TagStatus.success));
    } else {
      emit(state.copyWith(status: TagStatus.failed, message: response.message));
    }
  }

  _filterTags(FilterTags event, Emitter<TagState> emit) async {
    List<Tag> selectedTags = event.selectedTags.map((tag) {
      return Tag.fromMap(tag);
    }).toList();
    articlesBloc.add(ArticleSortByCategories(tags: selectedTags));
    emit(state.copyWith(selectedTags: selectedTags));
  }
}