import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../SharedPrefrence/sharedPrefrence.dart';
import '../../themes/themeclass.dart';
import '../../voucher/activevoucherscreen.dart';
import '../profile_screen.dart';
import '../transactionscreen.dart';
import '../../voucher/voucherscreen.dart';
import 'homescreen.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;
  SharedPreference sharedPreference = SharedPreference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: getPages(_currentIndex),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(
              color: Colors.black, // Set label text color
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                (states) {
              if (states.contains(WidgetState.selected)) {
                return IconThemeData(color: ThemeClass.primaryColor);
              }
              return IconThemeData(color: Colors.black);
            },
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: onTabTapped,
          selectedIndex: _currentIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home_outlined, color: ThemeClass.primaryColor),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.swap_horiz, color: ThemeClass.primaryColor),
              icon: Icon(Icons.swap_horiz),
              label: 'Transaction',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.card_giftcard, color: ThemeClass.primaryColor),
              icon: Icon(Icons.card_giftcard),
              label: 'Voucher',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person_outlined, color: ThemeClass.primaryColor),
              icon: Icon(Icons.person_outlined),
              label: 'Profile',
            ),
          ],
          height: 60,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget getPages(int currentIndex) {
    Widget page;
    if (currentIndex == 0) {
      page = const HomeScreen();
    } else if (currentIndex == 1) {
      page = const Transactionscreen();
    } else if (currentIndex == 2) {
      page = ActiveVoucherScreen();
    } else {
      page = ProfileScreen();
    }
    return page;
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
