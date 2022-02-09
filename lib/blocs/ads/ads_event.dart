

import 'package:equatable/equatable.dart';

abstract class AdsEvent extends Equatable {

  const AdsEvent();

  @override
  List<Object> get props => [];
}

class RandomGetAds extends AdsEvent {
  const RandomGetAds();

  @override
  List<Object> get props => [];
}

class ClearAds extends AdsEvent {
  const ClearAds();

  @override
  List<Object> get props => [];
}