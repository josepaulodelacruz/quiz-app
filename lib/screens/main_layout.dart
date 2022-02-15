import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/tags/tag_bloc.dart';
import 'package:rte_app/blocs/tags/tag_event.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/widgets/bottom_navigator_bar.dart';
import 'package:rte_app/main.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/user.dart';
import "package:rte_app/router.dart" as OnRouter;
import 'package:rte_app/screens/home/home_screen.dart';
import 'package:rte_app/screens/profile/profile_screen.dart';
import 'package:rte_app/screens/profile/profile_settings_screen.dart';
import 'package:rte_app/screens/search/search_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver {
  int pageIndex = 0;
  final _navigatorKey = GlobalKey<NavigatorState>();
  late User user;
  List navKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  //
  // PusherOptions options = PusherOptions(
  //   host: '10.0.2.2',
  //   wsPort: 6001,
  //   encrypted: false,
  //   auth: PusherAuth(
  //     '${dev_endpoint}/broadcasting/auth',
  //     headers: {
  //       'Authorization': 'Bearer 6|ymTHC8bJz7NN2wSuBTwutayvWXWkDsOgn8QPfnnL',
  //     }
  //   )
  // );

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      context.read<ArticlesBloc>().add(ArticleGetEvent());
      context.read<TagBloc>().add(GetTags());
      context.read<ArticlesBloc>().add(GetUnfinishedReadArticle());
    });
    user = BlocProvider.of<AuthBloc>(context).state.user!;
    context.read<ArticlesBloc>().add(GetSavedArticles(userId: user.id));
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    ///detect app if it's in the background
    if(mounted) {
      switch(state) {
        case AppLifecycleState.paused:
          print('paused');
          setState(() {});
          break;
        case AppLifecycleState.resumed:
          print('resumed');
          context.read<ArticlesBloc>().add(GetUnfinishedReadArticle());
          break;
        case AppLifecycleState.inactive:
          print('inactive');
          context.read<ArticlesBloc>().add(ArticleSave());
          break;
        case AppLifecycleState.detached:
          print('detached');
          break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if(navKeys[pageIndex].currentState!.canPop()) {
            navKeys[pageIndex].currentState!.pop();
            return false;
          }
          return true;
        },
        child: IndexedStack(
          index: pageIndex,
          children: [
            HomeScreen(),
            ProfileScreen(
              user: user,
            ),
            SearchScreen(),
            ProfileSettingsScreen(user: user),
            // Navigator(
            //   key: navKeys[0],
            //   initialRoute: home_screen,
            //   // onGenerateRoute: OnRouter.PublicRouter.generateRoute,
            // ),
            // Navigator(
            //   key: navKeys[1],
            //   initialRoute: profile_screen,
            //   // onGenerateRoute: OnRouter.PublicRouter.generateRoute,
            // ),
            // Navigator(
            //   key: navKeys[2],
            //   initialRoute: profile_settings_screen,
            //   // onGenerateRoute: OnRouter.PublicRouter.generateRoute,
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigatorBarWidget(
        pageIndex: pageIndex,
        onTap: (val) {
          pageIndex = val;
          setState(() {});
        },
        navigatorKey: _navigatorKey,
      ),
    );
  }
}
