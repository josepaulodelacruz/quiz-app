import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/blocs/auth/auth_event.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/widgets/outline_button_widget.dart';
import 'package:rte_app/common/widgets/primary_button_widget.dart';
import 'package:rte_app/common/widgets/transparent_app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late ScrollController _controller;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isPasswordShow = true;
  bool isConfirmPasswordShow = true;
  final _formKey = GlobalKey<FormState>();
  Color backgroundColor = Colors.transparent;
  double elevation = 0;

  @override
  void initState () {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener () {
    if (_controller.offset >= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      backgroundColor = Colors.white;
      elevation = 1;
    }

    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      backgroundColor = COLOR_GRAY;
      elevation = 0;
    }
    setState(() {});
  }

  @override
  void dispose () {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TransparentAppBarWidget(elevation: elevation, backgroundColor: backgroundColor),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SizedBox(
            height: SizeConfig.screenHeight!,
            width: SizeConfig.screenWidth!,
            child: SingleChildScrollView(
              controller: _controller,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical! * 15,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Create\nAccount",
                          style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: COLOR_PURPLE,
                          ),
                        ),
                      ),
                    ),
                    // textFieldWidget(label: "Email Address"),
                    // textFieldWidget(label: "Password"),
                    SizedBox(height: 20),
                    textFieldWidget(label: "Email Address", controller: email),
                    textFieldWidget(
                      label: "Password",
                      controller: password,
                      obsureText: isPasswordShow,
                      iconButton: IconButton(
                        onPressed: () {
                          isPasswordShow = !isPasswordShow;
                          setState(() {});
                        },
                        icon: Icon(isPasswordShow ? Icons.visibility_off : Icons.visibility, color: Colors.grey)
                      )
                    ),
                    textFieldWidget(
                      label: "Confirm Password",
                      obsureText: isConfirmPasswordShow,
                      controller: confirmPassword,
                        iconButton: IconButton(
                            onPressed: () {
                              isConfirmPasswordShow = !isConfirmPasswordShow;
                              setState(() {});
                            },
                            icon: Icon(isPasswordShow ? Icons.visibility_off : Icons.visibility, color: Colors.grey)
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text.rich(
                        TextSpan(
                            style: TextStyle(letterSpacing: .8),
                            children: [
                              TextSpan(
                                  text: "I have agree to the",
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: COLOR_PURPLE,
                                    fontSize: SizeConfig.blockSizeVertical! * 2,
                                    fontWeight: FontWeight.w400,
                                  )
                              ),
                              TextSpan(
                                  text: "Terms & Conditions ",
                                  recognizer: new TapGestureRecognizer()..onTap = () {
                                  },
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: COLOR_PINK,
                                    fontSize: SizeConfig.blockSizeVertical! * 2,
                                    fontWeight: FontWeight.w400,
                                  )
                              ),
                              TextSpan(
                                  text: "and ",
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: COLOR_PURPLE,
                                    fontSize: SizeConfig.blockSizeVertical! * 2,
                                    fontWeight: FontWeight.w400,
                                  )
                              ),
                              TextSpan(
                                  text: "Privacy Policy.",
                                  recognizer: new TapGestureRecognizer()..onTap = () {
                                  },
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: COLOR_PINK,
                                    fontSize: SizeConfig.blockSizeVertical! * 2,
                                    fontWeight: FontWeight.w400,
                                  )
                              ),
                            ]
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: PrimaryButtonWidget(
                        onPressed: _handleSubmit,
                        color: COLOR_PINK,
                        child: Text(
                          "Create Account",
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: COLOR_WHITE,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                  text: "Already have an account? ",
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: COLOR_PURPLE,
                                    fontSize: SizeConfig.blockSizeVertical! * 2,
                                    fontWeight: FontWeight.w400,
                                  )
                              ),
                              TextSpan(
                                  text: "Login",
                                  recognizer: new TapGestureRecognizer()..onTap = () {
                                  },
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: COLOR_PINK,
                                    fontSize: SizeConfig.blockSizeVertical! * 2,
                                    fontWeight: FontWeight.w400,
                                  )
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldWidget(
      {required String label, TextEditingController? controller, bool? isPassword = false, IconButton? iconButton, bool? obsureText = false}) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20, top: 15),
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
            obscureText: obsureText!,
            validator: (text) {
              if(text!.isEmpty) {
                return "$label is required!";
              }

              return null;
            },
            controller: controller,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              suffixIcon: iconButton,
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

  void _handleSubmit () {
    bool status = _formKey.currentState!.validate();
    if(status) {
      context.read<AuthBloc>().add(AuthRegister(email: email.text, password: password.text, confirmPassword: confirmPassword.text));
      // Navigator.pushNamed(context, profile_screen);
    }

  }
}
