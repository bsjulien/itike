import 'package:flutter/material.dart';
import 'package:itike/pages/dashboard_page.dart';
import 'package:itike/pages/destination_page.dart';
import 'package:itike/pages/startpoint_page.dart';
import 'package:itike/pages/tickets_page.dart';

import '../utils/colors.dart';

class MainPage extends StatefulWidget {
  late int currentIndex;
  MainPage({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // static const List<Widget> _pages = [
  //   DashboardPage(),
  //   StartPointPage(),
  //   TicketsPage()
  // ];

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  void onTap(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[widget.currentIndex].currentState!.maybePop();

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        // body: _pages[currentIndex],
        bottomNavigationBar: Container(
          height: 90,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.mainColor.withOpacity(0.2),
                spreadRadius: -20,
                blurRadius: 104,
                offset: Offset(0, -7), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            child: BottomNavigationBar(
                onTap: onTap,
                currentIndex: widget.currentIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Color(0xFFFAFAFA),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                iconSize: 30,
                selectedItemColor: AppColors.mainColor,
                unselectedItemColor: AppColors.mainColor,
                items: [
                  BottomNavigationBarItem(
                      label: 'home',
                      icon: ImageIcon(
                        AssetImage("assets/images/home.png"),
                      ),
                      activeIcon: ImageIcon(
                        AssetImage("assets/images/home_active.png"),
                      )),
                  BottomNavigationBarItem(
                      label: 'add',
                      icon: ImageIcon(
                        AssetImage("assets/images/add.png"),
                      ),
                      activeIcon: ImageIcon(
                        AssetImage("assets/images/add_active.png"),
                      )),
                  BottomNavigationBarItem(
                      label: 'tickets',
                      icon: ImageIcon(
                        AssetImage("assets/images/tickets.png"),
                      ),
                      activeIcon: ImageIcon(
                        AssetImage("assets/images/tickets_active.png"),
                      ))
                ]),
          ),
        ),

        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
          ],
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [DashboardPage(), StartPointPage(), TicketsPage()]
            .elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    final Map routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: widget.currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}
