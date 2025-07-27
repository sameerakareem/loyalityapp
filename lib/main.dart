import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posibolt_loyality/screens/homescreen/home.dart';
import 'package:posibolt_loyality/screens/loginscreen/loginscreen.dart';
import 'package:posibolt_loyality/screens/otpscreen/otpscreen.dart';
import 'package:posibolt_loyality/screens/splashscreen/splashscreen.dart';
import 'package:posibolt_loyality/voucher/voucherscreen.dart';
import 'screens/homescreen/homescreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure proper initialization
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/" : (context) => SplashScreen(),
        "/loginscreen" : (context) => LoginScreen(),
        "/otpscreen" : (context) => OtpScreen(),
        "/homescreen" : (context) => HomeScreen(),
        "/home" : (context) => Home(),
        "/voucherscreen" : (context) => VoucherScreen()

      },
      title: 'Al-Maqsood',
      theme: ThemeData(primarySwatch: Colors.blue,),
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        );
      },
    );
  }
}

