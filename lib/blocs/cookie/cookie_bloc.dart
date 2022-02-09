import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/cookie/cookie_event.dart';
import 'package:rte_app/blocs/cookie/cookie_state.dart';
import 'package:rte_app/common/utils.dart';
import 'package:rte_app/models/cookie.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

List months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

class CookieBloc extends Bloc<CookieEvent, CookieState> {
  AppUtil _appUtil = AppUtil();

  CookieBloc() : super(CookieState.unknown()) {
    on<CookieStore>(_storeCookie);
  }

  _storeCookie(CookieStore event, Emitter<CookieState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Cookie a = _appUtil.parseCookie(event.cookie!);
    print(a.session);
    var parseDate = a.expirationDate.toString().split(' ');
    var isDate = parseDate[2].split('-');
    var convertStringMonthToDate = months.indexWhere((el) => el == isDate[1]);
    String d = "${isDate[2]}-${(convertStringMonthToDate + 1)
        .toString()
        .length >= 2 ? (convertStringMonthToDate + 1) : "0${convertStringMonthToDate + 1}" }-${isDate[0]} ${parseDate[3]}";
    var z = DateTime.parse(d);
    print('$z = ${DateTime.now()}');
    if(z.isAfter(DateTime.now())) {
      prefs.setString('token', "");
      emit(state.copyWith(status: CookieStatus.expired));
    } else {
      emit(state.copyWith(cookie: a, status: CookieStatus.notExpired));
    }
  }

}