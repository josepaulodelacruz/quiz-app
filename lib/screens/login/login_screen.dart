import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/blocs/auth/auth_event.dart';
import 'package:rte_app/blocs/auth/auth_state.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/utils.dart';
import 'package:rte_app/common/widgets/outline_button_widget.dart';
import 'package:rte_app/common/widgets/primary_button_widget.dart';
import 'package:rte_app/common/widgets/transparent_app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/common/widgets/util.dart';
import 'package:rte_app/main.dart';
import 'package:rte_app/screens/main_layout.dart';
import 'package:rte_app/screens/splash_screen.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppUtil _appUtil = AppUtil();
  TextEditingController email = TextEditingController(text: 'jerel.stamm@example.net');
  TextEditingController password = TextEditingController(text: 'password');
  bool isShow = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.loading:
            modalHudLoad(context);
            break;
          case AuthStatus.success:
            Navigator.pop(context);
            Navigator.pushNamed(context, 'main_layout');
            break;
          case AuthStatus.failed:
            Navigator.pop(context);
            _appUtil.errorModal(context, title: "Failed login", message: state.message);
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: TransparentAppBarWidget(),
        body: SizedBox(
          height: SizeConfig.screenHeight!,
          width: SizeConfig.screenWidth!,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: SizeConfig.blockSizeVertical! * 20,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: COLOR_PURPLE,
                            ),
                      ),
                    ),
                  ),
                  textFieldWidget(label: "Email Address", controller: email),
                  textFieldWidget(
                      label: "Password",
                      controller: password,
                      isPassword: true),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: PrimaryButtonWidget(
                      onPressed: _handleLogin,
                      color: COLOR_PINK,
                      child: Text(
                        "Sign in",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: COLOR_WHITE,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: OutlineButtonWidget(
                      onPressed: () {},
                      color: COLOR_PINK,
                      child: Text(
                        "Sign in with Google",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: COLOR_PURPLE,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(letterSpacing: .8),
                        children: [
                          TextSpan(
                              text: "Need account? click ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: COLOR_PURPLE,
                                    fontSize: SizeConfig.blockSizeVertical! * 2,
                                    fontWeight: FontWeight.w400,
                                  )),
                          TextSpan(
                            text: "Here ",
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, registration_screen);
                              },
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  color: Colors.red,
                                  fontSize: SizeConfig.blockSizeVertical! * 2,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          TextSpan(
                            text: "to create an account.",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  color: COLOR_PURPLE,
                                  fontSize: SizeConfig.blockSizeVertical! * 2,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldWidget(
      {required String label,
      TextEditingController? controller,
      bool? isPassword = false}) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: COLOR_PURPLE,
                  fontSize: SizeConfig.blockSizeVertical! * 3,
                ),
          ),
          SizedBox(height: 10),
          TextFormField(
            obscureText: isPassword! ? isShow : false,
            controller: controller,
            validator: (text) {
              if (text!.isEmpty) {
                return "$label is required!";
              }
              return null;
            },
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              suffixIcon: isPassword
                  ? IconButton(
                      onPressed: () {
                        isShow = !isShow;
                        setState(() {});
                      },
                      icon: Icon(
                          isShow ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey),
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_PURPLE),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() async {
    bool status = _formKey.currentState!.validate();
    if (status) {
      context
          .read<AuthBloc>()
          .add(AuthLogin(email: email.text, password: password.text));
    }
  }
}
