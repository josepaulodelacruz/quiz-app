import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/widgets/transparent_app_bar_widget.dart';
import 'package:rte_app/main.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:sensitive_http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          child: Icon(Icons.add),
        ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: TextField(
              onChanged: (text) async  {
              },
            ),
          ),
          body: ListView(
            children: [],
          )),
    );
  }
}
