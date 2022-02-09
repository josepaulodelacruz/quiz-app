

import 'package:equatable/equatable.dart';
import 'package:rte_app/models/article.dart';

abstract class TagEvent extends Equatable {
  const TagEvent();

  @override
  List<Object> get props => [];
}

class GetTags extends TagEvent {
  const GetTags();

  @override
  List<Object> get props => [];
}

class FilterTags extends TagEvent {
  final List<Map<String, dynamic>> selectedTags;

  const FilterTags({
    this.selectedTags = const [],
  });

  @override
  List<Object> get props => [selectedTags];
}