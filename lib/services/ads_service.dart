

import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/errors.dart';
import 'package:rte_app/services/api_service.dart';
import 'package:rte_app/main.dart';

class AdsResponse {
  String? message;
  int? status;
  bool? error;
  Map<String, dynamic>? collections;

  AdsResponse({
    this.message,
    this.status,
    this.error,
    this.collections,
  });

  factory AdsResponse.fromMap(Map<String, dynamic> map) {
    var model = AdsResponse();
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


class AdsService extends ApiService {
  BaseCacheManager _cacheManager = DefaultCacheManager();
  // BaseCacheManager _cacheManager = DefaultCacheManager();

  AdsService() : super(endpoint: dev_endpoint);

  Future<AdsResponse> getRandomAds() async {
    try {
      var token = getIt<CookieBloc>().state.cookie!.session;
      var response = await get('/api/user/get-ads', token.toString());
      response['status'] = 200;
      return AdsResponse.fromMap(response);
    } on ApiResponseError catch (error) {
      return AdsResponse(
        status: 400,
        error: true,
        message: error.message,
      );
    } catch (error) {
      return AdsResponse(
        status: 404,
        error: true,
        message: "Something went wrong",
      );
    }
  }

 Future<FileInfo>? cacheAdsVideo (String url) async {
    final fileInfo = await _cacheManager.getFileFromCache(url);
    if(fileInfo == null || fileInfo.file == null) {
      print('downloading');
      final downloadFile = await _cacheManager.downloadFile(url);
      return downloadFile;
    } else {
      print('cache');
      return fileInfo;
    }
   // try {
   //
   //   FileInfo? fileInfo = await _cacheManager.downloadFile(url);
   //   print(fileInfo);
   //   print(fileInfo.file.path);
   //   print('saving');
   //   return fileInfo;
   // } catch (error) {
   //   print(error);
   //   throw error;
   // }
  }

  Future<FileInfo?> getCacheVideo (url) async {
    final fileInfo = await _cacheManager.getFileFromCache(url);
    return fileInfo;
  }

}