import 'package:equatable/equatable.dart';
import 'package:rte_app/models/article.dart';

enum TagStatus {
  waiting,
  loading,
  success,
  failed,
}

class TagState extends Equatable {
  final List<Tag> tags;
  final List<Tag> selectedTags;
  final TagStatus status;
  final String message;


  const TagState._({
    this.tags = const [],
    this.selectedTags = const [],
    this.status = TagStatus.waiting,
    this.message = "",
  });

  const TagState.unknown() : this._();

  TagState copyWith({
    List<Tag>? tags,
    List<Tag>? selectedTags,
    TagStatus? status,
    String? message,
  }) {
    return TagState._(
      tags: tags ?? this.tags,
      selectedTags: selectedTags ?? this.selectedTags,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [tags, selectedTags, status, message];

}