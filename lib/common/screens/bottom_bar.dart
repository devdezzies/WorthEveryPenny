import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/common/widgets/unknown_page.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/route_animations.dart';
import 'package:swappp/features/analytics/screens/analytics_screen.dart';
import 'package:swappp/features/settings/screens/settings_screen.dart';
import 'package:swappp/features/home/screens/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swappp/features/settings/services/settings_service.dart';
import 'package:swappp/features/split-bill/screens/split_bill_screen.dart';
import 'package:swappp/features/transaction/screens/transaction_screen.dart';
import 'package:swappp/providers/user_provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 28;
  double bottomBarBorderWidth = 3;
  final SettingsService settingsService = SettingsService();

  List<Widget> pages = [];

  // callback when icon tapped
  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pages = [
      const HomeScreen(),
      const SplitBillScreen(),
      const UnknownPage(),
      const AnalyticsScreen(),
      _buildSettingsScreen(context)
    ];
  }

  // Method to build the SettingsScreen and pass the context
  Widget _buildSettingsScreen(BuildContext context) {
    return SettingsScreen(onLeave: (username, paymentNumber) {
      // Pass the context and other parameters to the updateSettings function
      settingsService.updateSettings(
          context: context,
          name: username,
          id: Provider.of<UserProvider>(context, listen: false).user.id,
          paymentNumber: paymentNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_page],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).push(createRouteCustom(
                  const TransactionScreen(),
                  const Offset(0.0, 1.0),
                  Offset.zero,
                  Curves.ease));
            });
          },
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            size: 45,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          selectedLabelStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          selectedItemColor: GlobalVariables.secondaryColor,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          backgroundColor: GlobalVariables.backgroundColor,
          selectedIconTheme: const IconThemeData(
              color: GlobalVariables.secondaryColor, size: 30),
          unselectedIconTheme:
              const IconThemeData(color: Colors.white, size: 30),
          onTap: updatePage,
          enableFeedback: false,
          items: [
            // HOME
            BottomNavigationBarItem(
                icon: SizedBox(
                  width: bottomBarWidth,
                  child: SvgPicture.asset(
                    'assets/icons/home-vector.svg',
                    width: 30,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/home-active.svg",
                  width: 30,
                ),
                label: "Home"),
            // MONEY
            BottomNavigationBarItem(
                icon: SizedBox(
                    width: bottomBarWidth,
                    child: SvgPicture.asset(
                      'assets/icons/bill-vector.svg',
                      width: 25,
                    )),
                activeIcon: SvgPicture.asset(
                  "assets/icons/bill-active.svg",
                  width: 25,
                ),
                label: "Split Bills"),
            // FAKE ITEM FOR GAP
            const BottomNavigationBarItem(icon: SizedBox.shrink(), label: ""),
            // PROFILE
            BottomNavigationBarItem(
                icon: SizedBox(
                  width: bottomBarWidth,
                  child: const Icon(Icons.signal_cellular_alt_rounded),
                ),
                activeIcon: const Icon(Icons.signal_cellular_alt_rounded),
                label: "Analytics"),
            BottomNavigationBarItem(
                icon: SizedBox(
                  width: bottomBarWidth,
                  child: const Icon(
                    Icons.settings,
                    size: 30,
                  ),
                ),
                activeIcon: const Icon(
                  Icons.settings,
                  size: 30,
                ),
                label: "Settings"),
          ],
        ));
  }
}
