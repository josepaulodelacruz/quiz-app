

import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/errors.dart';
import 'package:rte_app/services/api_service.dart';


class SearchResponse {
  String? message;
  int? status;
  Map<String, dynamic>? collections;
  bool error;

  SearchResponse({
    this.message,
    this.status,
    this.collections,
    this.error = false,
  });

  factory SearchResponse.fromMap(Map<String, dynamic> map) {
    var model = SearchResponse();
    if(map.containsKey('status') && map['status'] == 200) {
      model.message = map['message'];
      model.status = map['status'];
      model.collections = map['body'];
      model.error = false;
      return model;
    }
    model.message = map['message'];
    model.status = 400;
    model.error = true;
    return model;
  }

}

class SearchService extends ApiService {

  SearchService() : super(endpoint: dev_endpoint);

  Future<SearchResponse> search (String query) async {
    try {
      var response = await get('/api/user/search/${query}');
      return SearchResponse.fromMap(response);
    } on ApiResponseError catch(error) {
      return SearchResponse(
        status: 400,
        message: error.message,
        error: true,
      );
    } catch (error) {
      return SearchResponse(
        status: 500,
        error: true,
        message: error.toString(),
      );
    }
  }
}