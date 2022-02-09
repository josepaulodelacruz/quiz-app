import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rte_app/blocs/ads/ads_bloc.dart';
import 'package:rte_app/blocs/ads/ads_state.dart';
import 'package:rte_app/common/constants.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClaimRewardWidget extends StatefulWidget {
  final VoidCallback? onPressed;

  const ClaimRewardWidget({this.onPressed});

  _ClaimRewardWidgetState createState() => _ClaimRewardWidgetState();
}

class _ClaimRewardWidgetState extends State<ClaimRewardWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      // '${dev_endpoint}/ads/videos/1478529571.mp4',
      // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      BlocProvider.of<AdsBloc>(context).state.fileInfo!.file,
    );
    _initializeVideoPlayerFuture = _controller.initialize().then((_) async {
      _controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_controller.value.position);
    return AlertDialog(
      title: Text('Ads'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return VideoPlayer(_controller);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            "For you to claim rewards\n"
            "Please answer a short questionaire",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, VideoPlayerValue value, child) {
            if(value.duration == value.position) {
              return TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Future.delayed(Duration(milliseconds: 300));
                  widget.onPressed!();
                },
                child: Text(
                  "Proceed",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: COLOR_PURPLE,
                  ),
                ),
              );
            } else {
              return TextButton(
                onPressed: null,
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }
}
