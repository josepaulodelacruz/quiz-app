import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/blocs/auth/auth_event.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/utils.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/user.dart';
import 'package:rte_app/screens/splash_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final User? user;
  final List<Article> savedArticles;
  const ProfileSettingsScreen({Key? key, this.user, this.savedArticles = const []}) : super(key: key);

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  AppUtil _appUtil = AppUtil();

  @override
  Widget build(BuildContext context) {
    User user = BlocProvider.of<AuthBloc>(context).state.user!;
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 25),
                    child: CircleAvatar(
                      radius: SizeConfig.blockSizeVertical! * 10,
                      backgroundColor: COLOR_PURPLE,
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical! * 9.5,
                        backgroundColor: Colors.white,
                        child: FlutterLogo(size: SizeConfig.blockSizeVertical! * 11.5),
                      ),
                    )
                ),
                Text(
                  "${widget.user!.firstName} ${widget.user!.lastName}",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  user.email!,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: COLOR_PURPLE,
                    fixedSize: Size(SizeConfig.screenWidth! * .7, 40),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, profile_edit_screen);
                  },
                  child: Text(
                    "Edit Profile",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: SizeConfig.blockSizeVertical! * 2,
                      color: Colors.white,
                      letterSpacing: 5,
                    ),
                  )
                ),
                SizedBox(height: 20),
                Container(
                  color: COLOR_LIGHT_GRAY,
                  child: ListTile(
                    visualDensity: VisualDensity(vertical: -4),
                    title: Text(
                      "CONTENT",
                      style: Theme.of(context).textTheme.headline6!.copyWith(color: COLOR_DARK_GRAY, letterSpacing: 2.5),
                    )
                  ),
                ),
                menuSettings(label: "Saved / Like", onPressed: () {
                  context.read<ArticlesBloc>().add(GetLikesArticle(
                    userId: BlocProvider.of<AuthBloc>(context).state.user!.id ?? 0,
                  ));
                  Navigator.pushNamed(context, saves_likes_screen);
                }),
                menuSettings(label: "Account Settings"),
                menuSettings(
                  onPressed: () {
                    Navigator.pushNamed(context, payments_billins_earning_screen);
                  },
                  label: "Billing And Earnings",
                ),
                Container(
                  color: COLOR_LIGHT_GRAY,
                  child: ListTile(
                      visualDensity: VisualDensity(vertical: -4),
                      title: Text(
                        "PREFERENCES",
                        style: Theme.of(context).textTheme.headline6!.copyWith(color: COLOR_DARK_GRAY, letterSpacing: 2.5),
                      )
                  ),
                ),
                menuSettings(
                  label: "Language",
                  trailing: Text(
                    "ENGLISH",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),
                  )
                ),
                menuSettings(
                  label: "Dark Mode",
                  trailing: Switch(value: false, onChanged: (val) {}),
                ),
                menuSettings(
                  label: "Sign Out",
                  onPressed: () {
                    _appUtil.confirmModal(
                      context,
                      title: "Logout!",
                      message: "Are you sure you want to logout?",
                      cancelBtn: true,
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogout());
                        Navigator.pushNamedAndRemoveUntil(context, login_screen, (route) => true);
                      }
                    );
                  }
                ),
              ],
            ),
          )
        ),
      )
    );
  }

  Widget menuSettings ({ required String label, Widget? trailing, Function? onPressed}) {
    return ListTile(
      onTap: () => onPressed!(),
      visualDensity: VisualDensity(horizontal: -4, vertical: 0),
      leading: Icon(Icons.favorite_border),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: trailing,
    );
  }
}
