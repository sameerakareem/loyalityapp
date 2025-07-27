import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:posibolt_loyality/model/modelclass.dart';
import 'package:posibolt_loyality/voucher/voucherscreen.dart';

import '../SharedPrefrence/sharedPrefrence.dart';
import '../screens/widgets.dart';
import '../services/LoadingCircle.dart';
import '../services/services.dart';
import '../themes/themeclass.dart';
import 'barcodedisplayscreen.dart';

class ActiveVoucherScreen extends StatelessWidget {
  const ActiveVoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _ActiveVoucherScreen(),
    );
  }
}

class _ActiveVoucherScreen extends StatefulWidget {
  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<_ActiveVoucherScreen> {
  bool internetChecking = true;

  @override
  void initState() {
    super.initState();
    internetConnectionChecking();
  }

  void internetConnectionChecking() async {
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: internetChecking
          ? Scaffold(
              appBar: AppBar(
                title: const Text('Vouchers'),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Active Vouchers'),
                    Tab(text: 'Used Vouchers'),
                  ],
                ),
              ),
              body: const Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        ActiveVouchers(),
                        UsedVouchers(),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Set the button color
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const VoucherScreen(),
                        ),
                      );
                    },
                    child: Text('Generate Voucher'),
                  ),
                ),
              ))
          : Widgets.noInternetConnection(
              context,
              () {
                setState(() {
                  internetChecking = true;
                });
                //getActiveVoucher();
              },
            ),
    );
  }
}

class ActiveVouchers extends StatefulWidget {
  const ActiveVouchers({super.key});

  @override
  _ActiveVouchersState createState() => _ActiveVouchersState();
}

class _ActiveVouchersState extends State<ActiveVouchers> {
  bool internetChecking = true;
  bool isLoading = true;
  SharedPreference sharedPreference = SharedPreference();
  late List<ActiveVoucherModel?> activeVoucherModel = [];
  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    internetConnectionChecking();
    getActiveVoucher();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          isLoading
              ? Center(child: LoadingCircle())
              : Expanded(
                  child: activeVoucherModel.isNotEmpty
                      ? _buildListView()
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Lottie.asset(
                              'assets/images/empty.json',
                              width: 250.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: activeVoucherModel.length,
      itemBuilder: (BuildContext context, int index) {
        ActiveVoucherModel? loyalty = activeVoucherModel[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BarcodeDisplayScreen(
                  barcodeNumber: loyalty!.voucherNo,
                ),
              ),
            );
          },
          child: Card(
            elevation: 2,
            child: Container(
              color: ThemeClass.backgroundColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/gift-card.png',
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loyalty!.voucherNo,
                    style: const TextStyle(),
                  ),
                  Text(
                    loyalty!.dateCreated!,
                    style: const TextStyle(),
                  ),
                  IgnorePointer(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'D ', // Your icon or symbol
                            style: TextStyle(
                              fontFamily: 'AED', // or 'DirhamIcon'
                              fontWeight: FontWeight.bold,
                              color: ThemeClass.primaryColor,
                            ),
                          ),
                          TextSpan(
                            text:
                                " ${(loyalty.voucherAmt - loyalty.redeemedAmt).toInt()} ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ThemeClass.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Text(
                  //   " ${(loyalty.voucherAmt - loyalty.redeemedAmt).toInt()} AED",
                  //   style: const TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: ThemeClass.primaryColor,
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void internetConnectionChecking() async {
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });
  }

  Future getActiveVoucher() async {
    String customerId = sharedPreference.getLoyaltyUsersBpartnerId().toString();
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });
    activeVoucherModel = [];
    isLoading = true;
    setState(() {});
    activeVoucherModel = await ApiServices.getActivevouchers(customerId);
    activeVoucherModel =
        activeVoucherModel.where((voucher) => !voucher!.redeemed).toList();
    isLoading = false;
    setState(() {});
  }
}

//used
class UsedVouchers extends StatefulWidget {
  const UsedVouchers({super.key});

  @override
  _UsedVouchersState createState() => _UsedVouchersState();
}

class _UsedVouchersState extends State<UsedVouchers> {
  bool internetChecking = true;
  bool isLoading = true;
  SharedPreference sharedPreference = SharedPreference();
  late List<ActiveVoucherModel?> activeVoucherModel = [];
  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    internetConnectionChecking();
    getActiveVoucher();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          isLoading
              ? Center(child: LoadingCircle())
              : Expanded(
                  child: activeVoucherModel.isNotEmpty
                      ? _buildListView()
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Lottie.asset(
                              'assets/images/empty.json',
                              width: 250.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: activeVoucherModel.length,
      itemBuilder: (BuildContext context, int index) {
        ActiveVoucherModel? loyalty = activeVoucherModel[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BarcodeDisplayScreen(
                  barcodeNumber: loyalty!.voucherNo,
                ),
              ),
            );
          },
          child: Card(
            elevation: 2,
            child: Container(
              color: ThemeClass.backgroundColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/gift-card.png',
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loyalty!.voucherNo,
                    style: const TextStyle(),
                  ),
                  Text(
                    loyalty!.dateRedeemed!,
                    style: const TextStyle(),
                  ),
                  IgnorePointer(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'D ', // Your icon or symbol
                            style: TextStyle(
                              fontFamily: 'AED', // or 'DirhamIcon'
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text:"${loyalty.redeemedAmt.toInt()}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //
                  // Text(
                  //   "${loyalty.redeemedAmt.toInt()} AED",
                  //   style: const TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.red,
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void internetConnectionChecking() async {
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });
  }

  Future getActiveVoucher() async {
    String customerId = sharedPreference.getLoyaltyUsersBpartnerId().toString();
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });

    activeVoucherModel = [];
    isLoading = true;
    setState(() {});
    activeVoucherModel = await ApiServices.getActivevouchers(customerId);
    activeVoucherModel =
        activeVoucherModel.where((voucher) => voucher!.redeemed).toList();
    // Sorting
    activeVoucherModel = activeVoucherModel
        .where((voucher) => voucher!.redeemed)
        .toList()
      ..sort((a, b) => b!.dateRedeemed!.compareTo(a!.dateRedeemed!));
    isLoading = false;
    setState(() {});
  }
}
