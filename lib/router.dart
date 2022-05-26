import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/screen_arguments.dart';
import 'package:rte_app/models/user.dart';
import 'package:rte_app/screens/article/read_article_screen.dart';
import 'package:rte_app/screens/article/saved_article_screen.dart';
import 'package:rte_app/screens/article/show_article_screen.dart';
import 'package:rte_app/screens/category/category_screen.dart';
import 'package:rte_app/screens/home/home_screen.dart';
import 'package:rte_app/screens/launch/launch_screen.dart';
import 'package:rte_app/screens/login/login_screen.dart';
import 'package:rte_app/screens/main_layout.dart';
import 'package:rte_app/screens/onboarding/onboarding_main_screen.dart';
import 'package:rte_app/screens/payments/billing_earning_screen.dart';
import 'package:rte_app/screens/payments/payment_method_screen.dart';
import 'package:rte_app/screens/profile/profile_edit_screen.dart';
import 'package:rte_app/screens/profile/profile_screen.dart';
import 'package:rte_app/screens/profile/profile_settings_screen.dart';
import 'package:rte_app/screens/quiz/quiz_completed_screen.dart';
import 'package:rte_app/screens/quiz/quiz_screen.dart';
import 'package:rte_app/screens/registration/registration_screen.dart';
import 'package:rte_app/screens/profile/saved_likes_screen.dart';
import 'package:rte_app/screens/splash_screen.dart';

class PublicRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('Current route ${settings.name}');
    switch (settings.name) {
      case splash_screen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case onboard_screen:
        return MaterialPageRoute(builder: (_) => OnboardingMainScreen());
      case launch_screen:
        return MaterialPageRoute(builder: (_) => LaunchScreen());
      case login_screen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case registration_screen:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      case main_layout:
        return MaterialPageRoute(builder: (_) => MainLayout());
      case home_screen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case categories_screen:
        List<Tag> tags = settings.arguments as List<Tag>;
        return MaterialPageRoute(builder: (_) => CategoryScreen(tags: tags));
      case view_article:
        return MaterialPageRoute(
            builder: (_) => ShowArticleScreen());
      case read_article:
        ScreenArguments arguments = settings.arguments as ScreenArguments;
        return CupertinoPageRoute(
            builder: (_) => ReadArticleScreen(
                article: arguments.article,
                isViewedSavedArticle: arguments.isViewedSavedArticle));
      case saved_article_screen:
        return CupertinoPageRoute(builder: (_) => SavedArticleScreen());
      case quiz_screen:
        Article readArticle = settings.arguments as Article;
        return CupertinoPageRoute(
            builder: (_) => QuizScreen(article: readArticle));
      case quiz_completed:
        List<Map<String, dynamic>> result = settings.arguments as List<Map<String, dynamic>>;
        return CupertinoPageRoute(builder: (_) => QuizCompletedScreen(result: result));
      case profile_screen:
        String isView = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ProfileScreen(isViewUser: isView));
      case profile_settings_screen:
        return MaterialPageRoute(builder: (_) => ProfileSettingsScreen());
      case saves_likes_screen:
        return CupertinoPageRoute(builder: (_) => SavedLikesScreen());
      case profile_edit_screen:
        return CupertinoPageRoute(builder: (_) => EditProfileScreen());
      case payments_billins_earning_screen:
        return CupertinoPageRoute(builder: (_) => BillingEarningScreen());
      case payments_method_screen:
        return CupertinoPageRoute(builder: (_) => PaymentMethodScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No defined Routes')),
          ),
        );
    }
  }
}

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: splash_screen,
      builder: (_, GoRouterState state) => SplashScreen(),
    ),
  ]

);

// class PrivateRouter {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case 'main_layout':
//         return MaterialPageRoute(builder: (_) => MainLayout());
//       case home_screen:
//         return MaterialPageRoute(builder: (_) => HomeScreen());
//       case categories_screen:
//         return MaterialPageRoute(builder: (_) => CategoryScreen());
//       case view_article:
//         // return MaterialPageRoute(builder: (_) => ShowArticleScreen());
//       case read_article:
//         return CupertinoPageRoute(builder: (_) => ReadArticleScreen());
//       case saved_article_screen:
//         return CupertinoPageRoute(builder: (_) => SavedArticleScreen());
//       case quiz_screen:
//         return CupertinoPageRoute(builder: (_) => QuizScreen());
//       case quiz_completed:
//         return CupertinoPageRoute(builder: (_) => QuizCompletedScreen());
//       case profile_screen:
//         return MaterialPageRoute(builder: (_) => ProfileScreen());
//       case profile_settings_screen:
//         return MaterialPageRoute(builder: (_) => ProfileSettingsScreen());
//       default:
//         return MaterialPageRoute(
//           builder: (_) => const Scaffold(
//             body: Center(child: Text('No defined Routes')),
//           ),
//         );
//     }
//   }
// }
