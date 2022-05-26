import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/ads/ads_bloc.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:rte_app/blocs/cookie/cookie_event.dart';
import 'package:rte_app/blocs/counter_bloc.dart';
import 'package:rte_app/blocs/search/search_bloc.dart';
import 'package:rte_app/blocs/tags/tag_bloc.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/models/article.dart';
import "package:rte_app/router.dart" as OnRouter;
import 'package:rte_app/screens/websocket_screen.dart';
import 'package:rte_app/services/ads_service.dart';
import 'package:rte_app/services/article_service.dart';
import 'package:rte_app/services/auth_service.dart';
import 'package:rte_app/services/search_service.dart';
import 'package:rte_app/services/tag_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  getIt.registerSingleton(CookieBloc());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState () {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: AuthService()),
        ),
        BlocProvider<ArticlesBloc>(
          create: (context)  {
            return ArticlesBloc(articleService: ArticleService());
          },
        ),
        BlocProvider<TagBloc>(
          create: (context) => TagBloc(tagService: TagService(), articlesBloc: context.read<ArticlesBloc>()),
        ),
        BlocProvider<CookieBloc>(
          create: (context) => CookieBloc(),
        ),
        BlocProvider<AdsBloc>(
          create: (context) => AdsBloc(adsService: AdsService()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(searchService: SearchService()),
        )
      ],
      // child: MaterialApp.router(
      //   title: "testing",
      //   routerDelegate: OnRouter.router.routerDelegate,
      // ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: createTheme(context),
        title: "RTE",
        // home: WebSocketScreen(),
        initialRoute: splash_screen,
        onGenerateRoute: OnRouter.PublicRouter.generateRoute,
      ),
    );
  }
}
