

import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/errors.dart';
import 'package:rte_app/main.dart';
import 'package:rte_app/services/api_service.dart';

class TagResponse {
  String message;
  bool? error;
  int? status;
  List<dynamic>? collections;

  TagResponse({
    this.message = "",
    this.error,
    this.status,
    this.collections,
  });

  factory TagResponse.fromMap(Map<String, dynamic> map) {
    var model = TagResponse();
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

class TagService extends ApiService {
  TagService () :
        super(endpoint: dev_endpoint);

  Future<TagResponse> getTags () async {
    try {
      var response = await get('/api/user/get-tags');
      return TagResponse.fromMap(response);
    } catch (error) {
      return TagResponse(message: error.toString(), error: true);
    }
  }


}