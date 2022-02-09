

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rte_app/models/ads.dart';
import 'package:meta/meta.dart';

enum AdsStatus {
  waiting,
  loading,
  success,
  failed,
}

class AdsState {
  const AdsState._({
    this.ads = Ads.empty,
    this.status = AdsStatus.waiting,
    this.fileInfo,
  });

  final Ads ads;
  final AdsStatus status;
  final FileInfo? fileInfo;

  const AdsState.unknown() : this._();

  AdsState copyWith({
    Ads? ads,
    AdsStatus? status,
    FileInfo? fileInfo,
  }) {
    return AdsState._(
      ads: ads ?? this.ads,
      status: status ?? this.status,
      fileInfo: fileInfo ?? this.fileInfo,
    );
  }
  List<Object> get props => [ads, status];
}