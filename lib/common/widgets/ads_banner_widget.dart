import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/ads/ads_bloc.dart';
import 'package:rte_app/blocs/ads/ads_state.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';

class AdsBannerWidget extends StatelessWidget {
  const AdsBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsBloc, AdsState>(
      builder: (context, state) {
        return  CachedNetworkImage(
          imageUrl: '${dev_endpoint}/ads/images/footer/footer-ads-default.jpg',
          fit: BoxFit.cover,
          placeholder: (_, __) {
            return Placeholder();
          },
        );
      }
    );
  }
}

