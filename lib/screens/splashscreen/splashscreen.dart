import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:posibolt_loyality/SharedPrefrence/sharedPrefrence.dart';
import 'package:posibolt_loyality/themes/themeclass.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late double screenWidth;
  late double screenHeight;
  SharedPreference sharedPreference = SharedPreference();
  String _version = ''; // Declare _version as a state variable

  @override
  void initState() {
    super.initState();
    _load();
    Future.delayed(const Duration(seconds: 2), () => checkLoginAndNavigate(context));
  }

  Future<void> _load() async {
    PackageInfo packageinfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageinfo.version;  // Use setState to update the state
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            color: Colors.white,
            child: Center(
              child: Image.asset(ThemeClass.companyIconImages, width: screenWidth * 0.4),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(ThemeClass.poweredByIcon, height: 30, width: 130, fit: BoxFit.fill),
                    Text(
                     // 'Version :1.1.1.02',

                       'Version :'+_version,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkLoginAndNavigate(BuildContext context) async {
    try {
      int? _bPartnerId = sharedPreference.getLoyaltyUsersBpartnerId();
      if (_bPartnerId != null && _bPartnerId != 0) {
        Navigator.popAndPushNamed(context, "/home");
      } else {
        Navigator.popAndPushNamed(context, "/loginscreen");
      }
    } catch (e) {
      Navigator.popAndPushNamed(context, "/loginscreen");
    }
  }
}
