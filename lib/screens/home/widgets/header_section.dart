import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/auth/auth_bloc.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/models/user.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = BlocProvider.of<AuthBloc>(context).state.user!;
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      height: SizeConfig.screenHeight! * .23,
      width: double.infinity,
      decoration: BoxDecoration(
          color: COLOR_PURPLE,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 5),
            )
          ],
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text(
          //   "Hello, ${user.fullName!}",
          //   style: Theme.of(context).textTheme.headline4!.copyWith(
          //     color: Colors.white,
          //   ),
          // ),
          SizedBox(height: 10),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "GEM: 40.50",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Colors.white
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: COLOR_PINK,
              ),
            ),
          )

        ],
      ),
    );
  }
}
