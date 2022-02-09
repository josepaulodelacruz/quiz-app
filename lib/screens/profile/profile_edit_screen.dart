import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/blocs/auth/auth_event.dart';
import 'package:rte_app/blocs/auth/auth_state.dart';
import 'package:rte_app/common/utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AppUtil _appUtil = AppUtil();
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  void initState () {
    fullName.text = BlocProvider.of<AuthBloc>(context).state.user!.firstName!;
    email.text = BlocProvider.of<AuthBloc>(context).state.user!.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_PURPLE,
        title: Text(
          "Update Profile",
          style: Theme.of(context).textTheme.headline6!.copyWith(
            color: Colors.white,
          ),
        )
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state.status == AuthStatus.loading) {
            _appUtil.modalHudLoad(context);
          } else if(state.status == AuthStatus.success) {
            Navigator.pop(context);
            _appUtil.confirmModal(context, title: "Success", message: state.message, onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          } else if(state.status == AuthStatus.failed) {
            Navigator.pop(context);
            _appUtil.errorModal(context, message: state.message);
          }
        },
        child: SafeArea(
          child: SizedBox(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Full Name:",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: fullName,
                        autofocus: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PURPLE),
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Email:",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: email,
                        autofocus: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PURPLE),
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: COLOR_PURPLE,
                      ),
                      onPressed: _handleSubmit,
                      child: Text("Update")
                    ),
                  )
                ],
              ),
            )
          )
        ),
      ),
    );
  }

  void _handleSubmit () async {
    context.read<AuthBloc>().add(AuthUpdateUser(fullName: fullName.text, email: email.text));
  }
}
