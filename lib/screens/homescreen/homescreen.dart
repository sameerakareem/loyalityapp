import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:posibolt_loyality/SharedPrefrence/sharedPrefrence.dart';
import 'package:posibolt_loyality/model/modelclass.dart';
import 'package:posibolt_loyality/screens/widgets.dart';
import 'package:posibolt_loyality/services/services.dart';
import 'package:posibolt_loyality/themes/themeclass.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/LoadingCircle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreference sharedPreference = SharedPreference();
  LoyalityUserData? loyaltyUserData;
  late double screenWidth;
  late double screenHeight;
  bool internetChecking = true;
  bool isLoadingItem = true;
  late String appName = "";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    internetConnectionChecking();
    loadAppName();
    checkForUpdate();
    getLoyalityUserInformation();
  }

  Future<String?> getAppName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  void loadAppName() async {
    appName = (await getAppName())!;
    setState(() {});
  }
  Future<void> checkForUpdate() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        print('update available');
        showUpdateDialog();
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  void showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Update Available!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
              'A new version of the app is available. Do you want to update now?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Later'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                launchPlayStore();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
  void launchPlayStore() async {
    const appId = "com.posibolt.almaqsoud_loyality";
    const appStoreId = "com.posibolt.almqsoud";

    String url = '';

    if (Platform.isAndroid) {
      url = "https://play.google.com/store/apps/details?id=$appId";
    } else if (Platform.isIOS) {
      url = "https://apps.apple.com/app/id$appStoreId";
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch store URL');
    }
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }
  void calculate() async {
    int value = loyaltyUserData != null
        ? (loyaltyUserData!.points * loyaltyUserData!.valueNumber) ~/ loyaltyUserData!.pointsRequired
        : 0;
    _controller.text = '$value';
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return internetChecking == true
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                appName,
                style: TextStyle(
                  fontSize: 18,
                  color: ThemeClass.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: isLoadingItem
                ? Center(child: LoadingCircle())
                : SingleChildScrollView(
                    child: Container(
                      height: screenHeight * 1,
                      width: screenWidth * 1,
                      //color: ThemeClass.backgroundColor,
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: Text(
                          //     'Hello,',
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: Text(
                          //     loyaltyUserData!.customerName,
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: ThemeClass.backgroundboxColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Points',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Image.asset(
                                                'assets/images/point.png',
                                                width: 24,
                                                height: 24,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            height: 60,
                                            child: Text(
                                              (loyaltyUserData?.points ?? 0).toInt().toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: ThemeClass.primaryColor,
                                                fontSize: 18,
                                                height: 1.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.swap_horiz,
                                      color: ThemeClass.primaryColor,
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Add some space between the sections
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Value',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Image.asset(
                                                'assets/images/value.png',
                                                width: 24,
                                                height: 24,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            height: 60,
                                            child:IgnorePointer(
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'D ', // Your icon or symbol
                                                      style: TextStyle(
                                                        fontFamily: 'AED', // or 'DirhamIcon'
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: ThemeClass.primaryColor,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: _controller.text,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: ThemeClass.primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),

                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),

                          SizedBox(
                            height: 10.0,
                          ),
                          Stack(
                            children: [
                              Container(
                                height: screenHeight * 0.545,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(36.0),
                                  color: ThemeClass.backgroundboxColor,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: screenHeight * 0.187,
                                      width: screenWidth * 1,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Scan barcode",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: screenHeight >
                                                        ThemeClass
                                                            .lowReslutionDevice
                                                    ? 34
                                                    : 32,
                                                color:
                                                    ThemeClass.boldTextColor),
                                          ),
                                          Text(
                                            "Scan and Collect Offer Points",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: screenHeight >
                                                        ThemeClass
                                                            .lowReslutionDevice
                                                    ? 15
                                                    : 14,
                                                color:
                                                    ThemeClass.lightTextColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const DottedLine(),
                                    Container(
                                      width: screenWidth * 1,
                                      height: screenHeight * 0.345,
                                      padding: EdgeInsets.only(
                                          top: screenHeight >
                                                  ThemeClass.lowReslutionDevice
                                              ? 30
                                              : 15,
                                          left: 20,
                                          right: 20,
                                          bottom: screenHeight >
                                                  ThemeClass.lowReslutionDevice
                                              ? 20
                                              : 15),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            BarcodeWidget(
                                              barcode: Barcode.code128(
                                                  useCode128B: true),
                                              data: loyaltyUserData
                                                          ?.loyaltyNo ==
                                                      null
                                                  ? "0"
                                                  : loyaltyUserData!.loyaltyNo,
                                              height: screenHeight * 0.22,
                                              width: screenHeight * .22,
                                              drawText: false,
                                              textPadding: 10,
                                              color: Colors.black,
                                              margin: const EdgeInsets.all(10),
                                            ),
                                            SizedBox(
                                              height: screenHeight >
                                                      ThemeClass
                                                          .lowReslutionDevice
                                                  ? 7.0
                                                  : 4,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    loyaltyUserData
                                                                ?.loyaltyNo ==
                                                            null
                                                        ? "0"
                                                        : loyaltyUserData!
                                                            .loyaltyNo,
                                                    style: const TextStyle(
                                                        fontFamily: "inter",
                                                        fontSize: 15,
                                                        color: ThemeClass
                                                            .lightTextColor),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: screenHeight * 0.17,
                                left: -30,
                                child: const ClipOval(
                                  child: Material(
                                    color: Color(0xffEDEDED),
                                    child: SizedBox(
                                      width: 50,
                                      height: 30,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: screenHeight * 0.17,
                                right: -30,
                                child: const ClipOval(
                                  child: Material(
                                    color: Color(0xffEDEDED),
                                    child: SizedBox(
                                      width: 50,
                                      height: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ))
        : Widgets.noInternetConnection(
            context,
            () {
              setState(() {
                internetChecking = true;
              });
              getLoyalityUserInformation();
            },
          );
  }

  void internetConnectionChecking() async {
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });
  }

  Future getLoyalityUserInformation() async {
    String loyaltyId = sharedPreference.getLoyaltyUsersBpartnerId().toString();
    var loyaltyData = await ApiServices.getLoyalityUserData(loyaltyId);
    setState(() {
      isLoadingItem = true;
    });

    ///dummy Loyalty ID : 60222978
    if (loyaltyData is LoyalityUserData) {
      setState(() {
        loyaltyUserData = loyaltyData;
        calculate();

        isLoadingItem = false;
      });
    }
  }

  void _bottomLogoutSheet(
      BuildContext context, LoyalityUserData? loyaltyUserList) async {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        builder: (builder) {
          return Container(
            padding: EdgeInsets.only(
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                top: 10.0,
                bottom: 15.0),
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0))),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                            'assets/images/bottom_bar_indicator.svg'),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10.0,
                          ),
                          ClipOval(
                            child: Material(
                              color: const Color(0xffE9E8EB),
                              child: InkWell(
                                splashColor: const Color(0xfff9f9f9),
                                child: Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: SvgPicture.asset(
                                      "assets/images/user_icon.svg",
                                      height: screenHeight * 0.027,
                                      color: const Color(0xff8E8E93),
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Flexible(
                            child: Text(
                              loyaltyUserList == null
                                  ? "Demo user"
                                  : loyaltyUserList.customerName.isEmpty
                                      ? "Default"
                                      : loyaltyUserList.customerName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff8E8E93)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 22.0,
                      ),
                      Center(
                        child: SizedBox(
                          height: screenHeight * 0.075,
                          width: screenWidth * 1,
                          child: ElevatedButton(
                            onPressed: () {
                              sharedPreference.eraseAllSharedPreferenceData();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/loginscreen", (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeClass.primaryColor,
                                shape: const StadiumBorder()),
                            child: const Text(
                              'Delete account',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffffffff)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
