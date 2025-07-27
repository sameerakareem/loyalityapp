import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:posibolt_loyality/voucher/activevoucherscreen.dart';

import '../SharedPrefrence/sharedPrefrence.dart';
import '../model/modelclass.dart';
import '../services/services.dart';
import '../themes/themeclass.dart';

import '../services/Toast.dart';
import 'barcodedisplayscreen.dart';




class VoucherScreen extends StatefulWidget {
  const VoucherScreen({Key? key}) : super(key: key);

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  SharedPreference sharedPreference = SharedPreference();
  LoyalityUserData? loyaltyUserData;
  late double screenWidth;
  late double screenHeight;
  bool internetChecking = true;
  bool isLoadingItem = true;
  late String appName ="";
  late double value;
  final TextEditingController _controllerPoints = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  late String _displayText = ' 0';
  bool isItemSyncing = false;

  @override
  void initState() {
    super.initState();
    internetConnectionChecking();
    getLoyalityUserInformation();
    _controllerPoints.addListener(() {
      if (_controllerPoints.text.isEmpty) {
        setState(() {
          _displayText = '';
        });
      }
    });
  }
  void internetConnectionChecking() async {
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });
  }
  void caluculateValue(int point)  {
     value = (point * loyaltyUserData!.valueNumber) / loyaltyUserData!.pointsRequired;
    setState(() {
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
  void calculate() async {
    int value = loyaltyUserData != null
        ? (loyaltyUserData!.points * loyaltyUserData!.valueNumber) ~/ loyaltyUserData!.pointsRequired
        : 0;
    _controller.text = '$value ';
    _displayText = '$value ';
    _controllerPoints.text = (loyaltyUserData?.points ?? 0).toInt().toString();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Generate Voucher',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => ActiveVoucherScreen(),
              ),
            );          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.black),
            onPressed: () {
              // Add sync functionality
            },
          ),
        ],
      ),
      body: Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(  // Added scroll view
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                            const SizedBox(height: 10,),

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
                      SizedBox(width: 8),  // Add some space between the sections
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10,),
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
                            Container(
                              height: 60,
                              child:IgnorePointer(
                                child: Text.rich(
                                  maxLines: 2,
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
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Enter Points',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: ThemeClass.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _controllerPoints,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 22),
                      suffixIcon: Image.asset(
                        'assets/images/value.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        String sanitizedValue = value.replaceAll(RegExp(r'[^0-9]'), '');

                        _controllerPoints.text = sanitizedValue;
                        _controllerPoints.selection = TextSelection.fromPosition(
                          TextPosition(offset: sanitizedValue.length),
                        );

                        if (sanitizedValue.isEmpty) {
                          _displayText = '';
                          return;
                        }

                        double _value = double.parse(sanitizedValue);
                        int result = (_value * loyaltyUserData!.valueNumber) ~/ loyaltyUserData!.pointsRequired;
                        _displayText = ' $result';

                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '=',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              // Converted value in AED
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue[50],
                ),

                child:IgnorePointer(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'D ', // Your icon or symbol
                          style: TextStyle(
                            fontFamily: 'AED', // or 'DirhamIcon'
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ThemeClass.primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: _displayText,
                          style: TextStyle(
                            fontSize: 24,
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
                //   _displayText,
                //   style: const TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.blue,
                //   ),
                // ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFD0D5DD),
                    width: 0.5, // Border width
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Use Points To Get a Voucher Containing a Cash amount You can Redeem at the Store',
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/point.png',
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(height: 5),
                              const Text('Add Points to Spend',
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/voucher.png',
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(height: 5),
                              const Text('Generate Voucher',
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/store.png',
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(height: 5),
                              const Text('Redeem at the Store',
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isItemSyncing
                    ? null:  () async {

                  // Parse entered points
                  double enteredPoints = double.tryParse(_controllerPoints.text) ?? 0;
                  // Check if entered points greater than zerp
                  if (enteredPoints <= 0.0) {
                    ApiServices.showErrorDialog(
                      context,
                       'Please enter a valid value.'
                    );
                    return;
                  }

                  // Check if entered points exceed available points
                  if (enteredPoints > loyaltyUserData!.points) {
                    ApiServices.showErrorDialog(
                      context,
                      'Entered points exceed available points (${loyaltyUserData!.points}).',
                    );
                    return;
                  }

                  //minimum point check
                  if (loyaltyUserData!.points < loyaltyUserData!.minPointsRequired) {
                    ApiServices.showErrorDialog(
                      context,
                      'You need a minimum of ${loyaltyUserData!.minPointsRequired} points to generate a voucher.',
                    );
                    return;
                  }

                  setState(() {
                    isItemSyncing = true;
                  });

                  double _pointsValue = ((enteredPoints * loyaltyUserData!.valueNumber) ~/ loyaltyUserData!.pointsRequired).toDouble();
                  if (_pointsValue <= 0) {
                    ApiServices.showErrorDialog(
                        context,
                        'Points must be greater than zero to proceed.'
                    );
                    isItemSyncing = false;
                    return;
                  }

                  VoucherDetails model=VoucherDetails(customerId: sharedPreference.getLoyaltyUsersBpartnerId(),pointsValue:_pointsValue ,points:double.parse(_controllerPoints.text) );
                  var data = jsonEncode(model.toJson());
                  print(data);
                  Map<String, dynamic> result = await ApiServices.generateVoucher(data);
                  if (result['success']) {
                    String recordNo = result['recordNo'];
                    //Toast.show("Voucher generated successfully! Record No: $recordNo", context, duration: 3);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BarcodeDisplayScreen(
                          barcodeNumber: recordNo,
                        ),
                      ),
                    );
                    setState(() {
                      isItemSyncing = false;
                    });
                  } else {
                    String error = result['error'];
                    setState(() {
                      isItemSyncing = false;
                    });
                    ApiServices.showErrorDialog(
                      context,
                      'Voucher generation failed! $error',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: ThemeClass.primaryColor,
                ),
                child: const Text(
                  'Generate Voucher',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ),

    );
  }

  @override
  void dispose() {
    _controllerPoints.dispose(); // Dispose of the controller when the widget is destroyed
    super.dispose();
  }
}
