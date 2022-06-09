import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/articles/articles_state.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/blocs/auth/auth_event.dart';
import 'package:rte_app/blocs/auth/auth_state.dart';
import 'package:rte_app/blocs/search/search_bloc.dart';
import 'package:rte_app/blocs/search/search_event.dart';
import 'package:rte_app/blocs/search/search_state.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/widgets/transparent_app_bar_widget.dart';
import 'package:rte_app/common/widgets/util.dart';
import 'package:rte_app/main.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/screens/search/widgets/search_card_article_widget.dart';
import 'package:rte_app/screens/search/widgets/search_card_author_widget.dart';
import 'package:rte_app/screens/search/widgets/search_card_user_widget.dart';
import 'package:sensitive_http/http.dart' as http;
import 'package:pusher_client/pusher_client.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // PusherClient pusher = PusherClient(
  //     "local_rte_key",
  //     PusherOptions(
  //       host: '10.0.2.2',
  //       wsPort: 6001,
  //       encrypted: false,
  //       auth: PusherAuth(
  //           '${dev_endpoint}/api/broadcasting/auth',
  //           headers: {
  //             'Authorization': 'Bearer eyJpdiI6IlhETlFDek1GeWdDSGdOckxMS0tjMGc9PSIsInZhbHVlIjoiTDB1K0s4MjFkaXdFUG9pNUpnN3N1RzZPYWtWbW5QS1UrWWo2Y2MwRHEvN0xVNkdQczZGdkljTXVXTWNCVUxDSCIsIm1hYyI6IjI0NDZhODVjOTFmMGRmNTAyNzMzODRiNDk4MjU2YmFhODM5OGFmZjc2YWQyNjk2NDk5OWNjZTczZjMyZDgxYmEiLCJ0YWciOiIifQ==',
  //           }
  //       ),
  //
  //       // auth: PusherAuth(
  //       //   '/api/broadcasting/auth',
  //       //   headers: {
  //       //     'Application': 'application/json',
  //       //     'Cookie': "laravel_session=7vjDQ28uAvwIMAnhVjU5cprmsQJ7trXvafk9M03y",
  //       //   }
  //       // )
  //     ), enableLogging: true, autoConnect: false);
  // late Channel channel;
  // late Channel privateChannel;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }
  //
  // Future<void> socket() async {
  //   try {
  //     await pusher.connect();
  //     channel = pusher.subscribe('home');
  //     print('socket');
  //     print(pusher.getSocketId());
  //
  //     channel.bind('App\\Events\\Test', (event) {
  //       print('listening');
  //       print(event!.data);
  //     });
  //
  //     privateChannel = pusher.subscribe('private-App.User.1');
  //     privateChannel.bind('App\\Events\\Word', (event) {
  //       print('listening from private channel');
  //       print(event!.data);
  //     });
  //
  //
  //     pusher.onConnectionError((error) {
  //       print('error');
  //       print(error!.message);
  //     });
  //
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: COLOR_LIGHT_GRAY,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: TextField(
                onChanged: (text) async  {
                  if(text.isNotEmpty) {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 800), () {
                      context.read<SearchBloc>().add(SearchQueryEvent(query: text));
                      FocusScope.of(context).unfocus();
                    });
                  } else {
                    context.read<SearchBloc>().add(SearchQueryEvent(query: text));
                    FocusScope.of(context).unfocus();
                    _debounce?.cancel();
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Search",
                  hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(color: COLOR_DARK_GRAY),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.mic)
                ),
              ),
            ),
            body: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if(state.status == SearchStatus.waiting) {
                  return Center(child: Text(
                    'Enter Article or Name',
                    style: Theme.of(context).textTheme.headline6,
                  ));
                } else if(state.status == SearchStatus.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.status == SearchStatus.success) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Popular Search",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          width: SizeConfig.screenWidth,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...state.queries['articles'].map((article) {
                                return  SearchCardArticleWidget(
                                  result: article,
                                  onPressed: () async {
                                    modalHudLoad(context);
                                    context.read<ArticlesBloc>().add(GetArticleById(articleId: article['id']));
                                    FocusScope.of(context).unfocus();
                                    await Future.delayed(Duration(milliseconds: 1000));
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, view_article);
                                  },
                                );
                              }).toList() ?? [],
                            ],
                          ),
                        ),
                        // ...state.queries['users'].map((user) {
                        //   return SearchCardUserWidget(
                        //     result: user,
                        //     onPressed: () async {
                        //       context.read<AuthBloc>().add(AuthViewUser(userId: user['id']));
                        //       context.read<ArticlesBloc>().add(GetSavedArticles(userId: user['id'], isViewSavedArticles: true));
                        //       modalHudLoad(context);
                        //       await Future.delayed(Duration(milliseconds: 1000));
                        //       Navigator.pop(context);
                        //       Navigator.pushNamed(context, profile_screen, arguments: 'view');
                        //     },
                        //   );
                        // }).toList() ?? [],
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Popular Author",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(width: 20),
                              ...state.queries['authors'].map((author) {
                                return SearchCardAuthorWidget(
                                  result: author,
                                  onPressed: () async {
                                    context.read<AuthBloc>().add(AuthViewAuthor(authorId: author['id'], status: ArticleStatus.viewAuthorArticle, bloc: context.read<ArticlesBloc>()));
                                    modalHudLoad(context);
                                    await Future.delayed(Duration(milliseconds: 1000));
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, profile_screen, arguments: 'author');
                                  },
                                );
                              }).toList() ?? [],
                            ],
                          ),
                        ),

                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('no search result'));
                }
              },
            )
        ),
      ),
    );
  }
}
