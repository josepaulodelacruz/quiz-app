import 'package:equatable/equatable.dart';

class Ads extends Equatable {
  final AdsBanner adsBanner;
  final AdsFooter adsFooter;
  final AdsVideo adsVideo;

  const Ads({
    this.adsBanner = AdsBanner.empty,
    this.adsFooter = AdsFooter.empty,
    this.adsVideo = AdsVideo.empty,
  });

  static const empty = Ads(adsBanner: AdsBanner.empty, adsFooter: AdsFooter.empty, adsVideo: AdsVideo.empty);

  factory Ads.fromMap(Map<String, dynamic> map) {
    return Ads(
      adsBanner: AdsBanner.fromMap(map['ads_banner']),
      adsFooter: AdsFooter.fromMap(map['ads_footer']),
      adsVideo: AdsVideo.fromMap(map['ads_video']),
    );
  }

  @override
  List<Object> get props => [];
}

class AdsBanner extends Equatable {
  final int id;
  final String title;
  final String image;
  final String link;

  const AdsBanner({
    this.id = 0,
    this.title = "",
    this.image = "",
    this.link = "",
  });

  static const empty = AdsBanner();

  factory AdsBanner.fromMap(Map<String, dynamic> map) {
    return AdsBanner(
      id: map['id'],
      title: map['title'],
      image: map['image'],
      link: map['link'] ?? "",
    );
  }

  @override
  List<Object> get props => [];
}

class AdsFooter extends Equatable {
  final int id;
  final String title;
  final String image;
  final String link;

  const AdsFooter({
    this.id = 0,
    this.title = "",
    this.image = "",
    this.link = "",
  });

  static const empty = AdsFooter();

  factory AdsFooter.fromMap(Map<String, dynamic> map) {
    return AdsFooter(
      id: map['id'],
      title: map['title'],
      image: map['image'],
      link: map['link'] ?? "",
    );
  }

  @override
  List<Object> get props => [];
}

class AdsVideo extends Equatable {
  final int id;
  final String title;
  final String video;
  final String link;

  const AdsVideo({
    this.id = 0,
    this.title = "",
    this.video = "",
    this.link = "",
  });

  static const empty = AdsVideo();

  factory AdsVideo.fromMap(Map<String, dynamic> map) {
    return AdsVideo(
      id: map['id'],
      title: map['title'],
      video: map['video'],
      link: map['link'] ?? "",
    );
  }

  @override
  List<Object> get props => [];
}
