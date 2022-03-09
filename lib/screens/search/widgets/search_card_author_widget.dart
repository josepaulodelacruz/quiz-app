import 'package:flutter/material.dart';

class SearchCardAuthorWidget extends StatelessWidget {
  Map<String, dynamic>? result;
  SearchCardAuthorWidget({Key? key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        elevation: .2,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${result!['first_name']} ${result!['last_name']}",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        )
    );
  }
}
