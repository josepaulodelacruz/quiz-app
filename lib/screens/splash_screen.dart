import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/blocs/auth/auth_event.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:rte_app/blocs/cookie/cookie_event.dart';
import 'package:rte_app/blocs/cookie/cookie_state.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState () =>
      _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState () {
    Future.delayed(Duration(seconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? user = prefs.getString('user-details');
      if(token == null || token == "") {
        Navigator.pushNamed(context, onboard_screen);
      } else {
        context.read<CookieBloc>().add(CookieStore(cookie: token));
        context.read<AuthBloc>().add(AuthPersistUser(user: user ?? ""));
      }

    });
    BlocProvider.of<CookieBloc>(context).stream.listen((state) {
      switch(state.status) {
        case CookieStatus.notExpired:
          getIt<CookieBloc>().emit(state.copyWith(cookie: state.cookie));
          Navigator.pushNamed(context, 'main_layout');
          break;
        case CookieStatus.expired:
          Navigator.pushNamed(context, onboard_screen);
          break;
        default:
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SizedBox(
        width: SizeConfig.screenWidth!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: SizeConfig.screenWidth! * .60,
              height: SizeConfig.screenHeight! * .30,
              child: Placeholder(),
            )
          ],
        ),
      ),
    );
  }
}
