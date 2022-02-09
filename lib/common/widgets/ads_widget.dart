import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/ads/ads_bloc.dart';
import 'package:rte_app/blocs/ads/ads_state.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/models/ads.dart';

class AdsWidget extends StatelessWidget {
  final Ads ads;

  const AdsWidget({Key? key, this.ads = Ads.empty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ads.adsBanner.title,
            style: Theme.of(context).textTheme.headline5,
          ),
          Expanded(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: '${dev_endpoint}/ads/images/banner/banner-ads-default.jpg',
                placeholder: (_, __) {
                  return Placeholder();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
