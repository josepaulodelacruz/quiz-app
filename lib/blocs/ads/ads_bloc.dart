

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rte_app/blocs/ads/ads_event.dart';
import 'package:rte_app/blocs/ads/ads_state.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/models/ads.dart';
import 'package:rte_app/services/ads_service.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  final AdsService adsService;

  AdsBloc({required this.adsService}) : super(AdsState.unknown()) {
    on<RandomGetAds>(_getRandomAds);
    on<ClearAds>(_clearStateAds);
  }

  _getRandomAds (RandomGetAds event, Emitter<AdsState> emit) async {
    var response = await adsService.getRandomAds();
    emit(state.copyWith(status: AdsStatus.loading));
    await Future.delayed(Duration(seconds: 1));
    if(!response.error!) {
      Ads a = Ads.fromMap(response.collections!);
      var adVideo = await adsService.cacheAdsVideo('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
      // var adVideo = adsService.cacheAdsVideo('${dev_endpoint}/ads/videos/1478529571.mp4');
      emit(state.copyWith(ads: a, status: AdsStatus.success, fileInfo: adVideo));
    } else {
      emit(state.copyWith(status: AdsStatus.failed));
    }
  }

  _clearStateAds(ClearAds event, Emitter<AdsState> emit) async {
    emit(state.copyWith(ads: Ads.empty, status: AdsStatus.waiting));
  }

}