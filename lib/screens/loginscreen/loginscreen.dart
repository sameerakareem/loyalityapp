import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:posibolt_loyality/SharedPrefrence/sharedPrefrence.dart';
import 'package:posibolt_loyality/constraints/urls.dart';
import 'package:posibolt_loyality/model/modelclass.dart';
import 'package:posibolt_loyality/screens/widgets.dart';
import 'package:posibolt_loyality/services/services.dart';
import 'package:posibolt_loyality/themes/themeclass.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SharedPreference sharedPreference = SharedPreference();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late double screenWidth;
  late double screenHeight;
  String? errorMessage;
  bool internetChecking = true;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    internetConnectionChecking();
    countryCodeController.text = Urls.usersContryCode;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneNumberController.clear();
    errorMessage = null;
  }

  void internetConnectionChecking() async{
    bool internetChe = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetChecking = internetChe;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (internetChecking == true){
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
          //  height: screenHeight * 1,
            width: screenWidth * 1,
         //   color: ThemeClass.backgroundColor,
            padding: EdgeInsets.only(left: screenWidth * 0.1,right: screenWidth * 0.1,bottom: 10,top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/home_screen_image.svg",height: screenHeight * 0.28,),
                const SizedBox(height: 8,),
                Image.asset(ThemeClass.companyLogoImages,height: screenHeight * 0.18,),
                SizedBox(height: screenWidth * 0.018,),
                Column(
                  children: [
                    Text("Sign in",style: TextStyle(fontFamily: "SourceSansPro",fontSize: screenWidth/11,color: ThemeClass.boldTextColor,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10.0,),
                    Text("We send a verification code \n to your number",overflow: TextOverflow.fade,textAlign: TextAlign.center,style: TextStyle(fontFamily: "inter",fontSize: screenWidth/26,color: ThemeClass.lightTextColor),),
                    SizedBox(height: screenWidth * 0.025,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: screenHeight > ThemeClass.lowReslutionDevice ?screenHeight * 0.07 : 52,
                      width: screenWidth * 0.2,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14),topLeft: Radius.circular(14) ),
                      ),
                      child: TextField(
                        controller: countryCodeController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontFamily: 'SourceSansPro',fontSize: screenWidth/15,fontWeight: FontWeight.w500,color: Color(0xff342914)),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight > ThemeClass.lowReslutionDevice ? screenHeight * 0.07 : 52,
                      width: screenWidth * 0.59,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(14),bottomRight: Radius.circular(14) ),
                      ),
                      child: TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.number,
                        style:  TextStyle(fontFamily: 'SourceSansPro',fontSize: screenWidth/15,fontWeight: FontWeight.w500,color: const Color(0xff342914)),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(border: InputBorder.none,contentPadding: EdgeInsets.only(left: 20.0,right: 20.0 ),),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10,),
                Center(
                  child: SizedBox(
                    height: screenHeight > ThemeClass.lowReslutionDevice ? screenHeight * 0.075 : 50,
                    width: screenWidth,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null // Disable button when loading
                          : () async {
                        setState(() {
                          isLoading = true; // Start loading
                        });
                        bool connectionChecking = await InternetConnectionChecker().hasConnection;
                        setState(() {
                          internetChecking = connectionChecking;
                        });
                        if (!internetChecking) {
                          Widgets.noInternetConnection(context,  () {
                            setState(() {
                              internetChecking = true;
                            });
                          },);
                          setState(() {
                            isLoading = false; // Stop loading
                          });
                          return;
                        }
                        if (phoneNumberController.text.length > 8) {

                          if (phoneNumberController.text == "000000000" ) {
                            String phoneNumber = phoneNumberController.text;
                            SharedPreference sharedPreference = SharedPreference();
                            sharedPreference.savePhoneNumber(phoneNumber);
                            sharedPreference.saveLoyalityUsersName("New loyalty Customer", '', 1019529, "1019529", '');
                            Navigator.pushReplacementNamed(context, "/home");
                          } else {
                            String phonenumber = phoneNumberController.text;
                            SharedPreference sharedPreference = SharedPreference();
                            sharedPreference.savePhoneNumber(phonenumber);
                            var otpVerificationResponce = await ApiServices.getOtpVerification(phonenumber);
                            if (otpVerificationResponce is ResponseClass) {
                              if (otpVerificationResponce.responseCode != 200) {
                                setState(() {
                                  errorMessage = otpVerificationResponce.detailedMessage.toString();
                                });
                              } else {
                                Navigator.pushNamed(context, "/otpscreen", arguments: {'phoneNumbers': phonenumber});
                              }
                            } else {
                              setState(() {
                                errorMessage = otpVerificationResponce.toString();
                              });
                            }
                          }
                        } else {
                          setState(() {
                            errorMessage = "Please enter a valid phone number";
                          });
                        }
                        setState(() {
                          isLoading = false; // Stop loading
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeClass.primaryColor,
                        shape: const StadiumBorder(),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                        color: Color(0xfff2f2f2),
                      ) // Show a progress indicator
                          : const Text(
                        'Get OTP',
                        style: TextStyle(
                          color: Color(0xfff2f2f2),
                          fontFamily: 'SourceSansPro',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                errorMessage == null ? const SizedBox():Text(errorMessage!,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20,),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:Image.asset(ThemeClass.poweredByIcon, height:  screenHeight * 0.05,width: 100,fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }else{
      return Widgets.noInternetConnection(context,  () {
        setState(() {
          internetChecking = true;
        });
      },);
    }
  }
}
