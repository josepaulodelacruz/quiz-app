

import 'package:equatable/equatable.dart';

class VerifiedArticlePagination extends Equatable  {
  final String urlNextPage;
  final String urlPrevPage;

  const VerifiedArticlePagination({
    this.urlPrevPage = "",
    this.urlNextPage = "",
  });

  static const empty = VerifiedArticlePagination();

  factory VerifiedArticlePagination.fromMap(Map<String, dynamic> map) {
    return VerifiedArticlePagination(
      urlNextPage: map['next_page_url'] ?? "",
      urlPrevPage: map['prev_page_url'] ?? "",
    );
  }


  @override
  List<Object?> get props => [urlNextPage, urlPrevPage];

}