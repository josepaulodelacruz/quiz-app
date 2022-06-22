

import 'package:flutter/material.dart';
import 'package:rte_app/common/size_config.dart';

class SearchCardAuthorWidget extends StatelessWidget {
  final Map<String, dynamic>? result;
  final VoidCallback? onPressed;
  const SearchCardAuthorWidget({Key? key, this.result, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.only(right: 15),
        child: Column(
          children: [
            CircleAvatar(
              radius: SizeConfig.blockSizeVertical! * 5,
              child: CircleAvatar(
                radius: SizeConfig.blockSizeVertical! * 4.5,
                backgroundImage: NetworkImage(result!['profile_picture']),
              ),
            ),
            Text(result!['first_name'])
          ],
        ),
      ),
    );
    // return GestureDetector(
    //   onTap: onPressed,
    //   child: Card(
    //       margin: EdgeInsets.all(10),
    //       elevation: .2,
    //       child: Container(
    //         padding: EdgeInsets.all(20),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               "${result!['first_name']} ${result!['last_name']}",
    //               style: Theme.of(context).textTheme.headline6,
    //             ),
    //           ],
    //         ),
    //       )
    //   ),
    // );
  }
}
