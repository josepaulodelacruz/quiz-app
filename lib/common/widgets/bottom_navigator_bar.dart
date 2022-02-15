import 'package:flutter/material.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/string_routes.dart';

class BottomNavigatorBarWidget extends StatefulWidget {
  int pageIndex;
  GlobalKey navigatorKey;
  Function? onTap;

  BottomNavigatorBarWidget({Key? key, required this.navigatorKey, required this.pageIndex, this.onTap}) : super(key: key);

  @override
  _BottomNavigatorBarWidgetState createState() => _BottomNavigatorBarWidgetState();
}

class _BottomNavigatorBarWidgetState extends State<BottomNavigatorBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: widget.pageIndex,
        onTap: (index) {
          widget.onTap!(index);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home, color: COLOR_PURPLE),
            icon: Icon(Icons.home, color: Colors.black),
            label: "Home",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person_pin, color: COLOR_PURPLE),
            icon: Icon(Icons.person_pin, color: Colors.black),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.search, color: COLOR_PURPLE),
            icon: Icon(Icons.search, color: Colors.black),
            label: "Search",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.settings, color: COLOR_PURPLE),
            icon: Icon(Icons.settings, color: Colors.black),
            label: "Settings",
          ),
        ]
    );
  }
}

