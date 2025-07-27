import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:posibolt_loyality/screens/widgets.dart';
import 'package:posibolt_loyality/services/LoadingCircle.dart';

import '../SharedPrefrence/sharedPrefrence.dart';
import '../model/modelclass.dart';
import '../services/services.dart';
import '../themes/themeclass.dart';
import 'homescreen/home.dart';

class Transactionscreen extends StatefulWidget {
  const Transactionscreen({Key? key}) : super(key: key);

  @override
  _TransactionscreenState createState() => _TransactionscreenState();
}

class _TransactionscreenState extends State<Transactionscreen> {
  late double screenWidth;
  late double screenHeight;
  bool internetChecking = true;
  bool isLoading = true;
  LoyalityUserData? loyaltyUserData;
  bool isLoadingItem = true;
  final TextEditingController _controller = TextEditingController();

  late List<LoyalityHistoryData?> loyaltyHistoryData = [];
  SharedPreference sharedPreference = SharedPreference();

  @override
  void initState() {
    super.initState();
    internetConnectionChecking();
    getLoyalityUserInformation();
    getLoyalityHistory();
  }

  void internetConnectionChecking() async {
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });
  }

  Future getLoyalityUserInformation() async {
    String customerId = sharedPreference.getLoyaltyUsersBpartnerId().toString();
    var loyaltyData = await ApiServices.getLoyalityUserData(customerId);
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

  void calculate() async {
    int value = loyaltyUserData != null
        ? (loyaltyUserData!.points * loyaltyUserData!.valueNumber) ~/
            loyaltyUserData!.pointsRequired
        : 0;
    _controller.text = '$value';
    setState(() {});
  }

  Future getLoyalityHistory() async {
    String loyaltyId = sharedPreference.getLoyaltyUsersBpartnerId().toString();
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });
    loyaltyHistoryData = [];
    isLoading = true;
    setState(() {});
    loyaltyHistoryData = await ApiServices.getLoyalityHistory(loyaltyId);
    isLoading = false;
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
    if (internetChecking == true) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Transaction History',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(),
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.sync,
                ),
                onPressed: () {
                  getLoyalityHistory();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    color: ThemeClass.backgroundboxColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                  (loyaltyUserData?.points ?? 0)
                                      .toInt()
                                      .toString(),
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
                            width: 8), // Add some space between the sections
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                child: IgnorePointer(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'D ', // Your icon or symbol
                                          style: TextStyle(
                                            fontFamily:
                                                'AED', // or 'DirhamIcon'
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
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 10),
                        SizedBox(width: 5),
                        Text(
                          'Earned',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.red, size: 10),
                      SizedBox(width: 5),
                      Text(
                        'Redeemed',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              isLoading
                  ? Center(child: LoadingCircle())
                  : Expanded(
                      //   height: MediaQuery.of(context).size.height,
                      child: _buildHistoryView(),
                    ),
            ],
          ));
    } else {
      return Widgets.noInternetConnection(
        context,
        () {
          setState(() {
            internetChecking = true;
          });
          getLoyalityUserInformation();
          getLoyalityHistory();
        },
      );
    }
  }

  Widget _buildHistoryView() {
    return ListView(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: loyaltyHistoryData.length,
          itemBuilder: (BuildContext context, int x) {
            LoyalityHistoryData? loyalty = loyaltyHistoryData[x];

            double pointsRedeemed = loyalty!.pointsRedeemed;
            double pointsEarned = loyalty.pointsEarned;

            bool isRedeemed = pointsRedeemed > 0;
            String pointsText = isRedeemed
                ? "-${pointsRedeemed.toStringAsFixed(0)}"
                : "+${pointsEarned.toStringAsFixed(0)}";
            Color pointsColor = isRedeemed ? Colors.red : Colors.green;
            Color backgound = isRedeemed
                ? ThemeClass.redeembackground
                : ThemeClass.earnedBackground;

            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Leading section: Icon and details
                    Flexible(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: backgound,
                            //   child: Icon(Icons.shopping_bag, color: Colors.grey.shade300), // Placeholder for actual image
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loyalty.orgName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  loyalty.invoiceNo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 15,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      loyalty.dateAcc,
                                      //style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Points earned or redeemed section
                    Column(
                      children: [
                        Text(
                          pointsText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: pointsColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
