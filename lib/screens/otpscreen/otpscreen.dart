import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:posibolt_loyality/SharedPrefrence/sharedPrefrence.dart';
import 'package:posibolt_loyality/model/modelclass.dart';
import 'package:posibolt_loyality/screens/widgets.dart';
import 'package:posibolt_loyality/services/services.dart';
import 'package:posibolt_loyality/themes/themeclass.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  SharedPreference sharedPreference = SharedPreference();
  OtpFieldController otpController = OtpFieldController();
  late double screenwidth;
  late double screenheight;
  late String phonenumber;
  String? errorMessage;
  bool internetChecking = true;
  bool _isResendAgain = false;
  late Timer _timer;
  int _start = 300;
  late AnimationController _controller;
  int levelClock = 300;

  @override
  void initState() {
    internetConnectionChecking();
    otpTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    otpController.clear();
    errorMessage = null;
    internetChecking = true;
    _controller.clearListeners();
    _timer.cancel();
  }

  void internetConnectionChecking() async{
     bool internetChe = await InternetConnectionChecker().hasConnection;
     setState(() {
       internetChecking = internetChe;
     });
  }

  void otpTimer() {
    setState(() {
      _isResendAgain = true;
    });
    _controller = AnimationController(vsync: this,
        duration: Duration(seconds: levelClock));
    _controller.forward();
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          otpController.clear();
          errorMessage = "OTP Expired !";
          _start = 300;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    phonenumber = arg['phoneNumbers'];
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    if (internetChecking == true){
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: screenheight * 1,
            width: screenwidth * 1,
            color: ThemeClass.backgroundColor,
            padding: EdgeInsets.only(left: screenwidth * 0.1,right: screenwidth * 0.1,bottom: 10,top: 50),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: ClipOval(
                        child: Material(
                          color: ThemeClass.backgroundColor, // Button color
                          child: InkWell(
                            splashColor: Colors.white, // Splash color
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const SizedBox(width: 40, height: 55,
                                child: Icon(Icons.arrow_back_ios, size: 27, color: Colors.black,)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:screenheight > ThemeClass.lowReslutionDevice ?  screenheight * 0.02 : 5,),
                    Text("Verify your\nphone number",overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: TextStyle(fontFamily: "SourceSanProBold",fontSize:screenheight > ThemeClass.lowReslutionDevice ?  34 : 29,color: ThemeClass.boldTextColor),),
                    SizedBox(height: screenheight * 0.02,),
                    Text("Enter your OTP code here",overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: TextStyle(fontFamily: "inter",fontSize:screenheight > ThemeClass.lowReslutionDevice ?  15 : 14,color: ThemeClass.lightTextColor),),
                    SizedBox(height: screenheight > ThemeClass.lowReslutionDevice ? screenheight * 0.07 : 20,),
                    OTPTextField(
                        controller: otpController,
                        length: 4,
                        width: screenwidth * 0.7,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 50,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 15,
                        style: const TextStyle(fontFamily: "SourceSanProBold",fontSize: 20,color: Color(0xff383838)),
                        onChanged: (pin) {},
                        onCompleted: (pin) async{
                          bool connectionChecking= await InternetConnectionChecker().hasConnection;
                          setState(() {
                            internetChecking = connectionChecking;
                          });
                          if(internetChecking == false){
                            Widgets.noInternetConnection(context ,  () {
                              setState(() {
                                internetChecking = true;
                              });
                            },);
                          }else {
                            try{
                              var otpValidation = await ApiServices.matchOtpPhonenumber(phonenumber, pin);
                              if(otpValidation is LoyaltyUserPersonalInfo)
                              {
                                if(otpValidation.bpartnerId == null || otpValidation.name == null)
                                {
                                  setState(() {
                                    errorMessage = "Invalid OTP";
                                  });
                                }
                                else {
                                  sharedPreference.saveLoyalityUsersName(otpValidation.name ?? '', otpValidation.lastname ?? '',otpValidation.bpartnerId ?? 0, otpValidation.bpartnerValue ?? '', otpValidation.loyaltyNo ?? '');
                                  Navigator.of(context).pushNamedAndRemoveUntil('/home',arguments: {'phoneNumbers' : phonenumber,}, (route) => false);
                                }
                              }else{
                                setState(() {
                                  errorMessage = otpValidation.toString();
                                });
                              }
                            }
                            catch (e){
                              setState(() {
                                errorMessage = e.toString();
                              });
                            }
                          }
                        }
                    ),
                    SizedBox(height: screenheight * 0.027,),
                    _isResendAgain ? Countdown(animation: StepTween(
                      begin: levelClock,
                      end: 0,
                    ).animate(_controller),) : const SizedBox(),
                    const SizedBox(height: 12,),
                    errorMessage == null ? const SizedBox():Text(errorMessage!,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    SizedBox(height: screenheight * 0.02,),
                    Text("Didn't receive any code?",overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: TextStyle(fontFamily: "inter",fontSize: screenheight > ThemeClass.lowReslutionDevice ? 15 : 14,color: ThemeClass.lightTextColor),),
                    SizedBox(height: screenheight * 0.02,),
                    GestureDetector(
                        onTap:_isResendAgain ? (){} :() async{
                          bool connectionChecking= await InternetConnectionChecker().hasConnection;
                          setState(() {
                            internetChecking = connectionChecking;
                          });
                          if(internetChecking == false){
                            Widgets.noInternetConnection(context,  () {
                              setState(() {
                                internetChecking = true;
                              });
                            },);
                          }else{
                            setState(() {
                              otpController.clear();
                              errorMessage = null;
                            });
                            try{
                              var otpVerificationResponce = await ApiServices.getOtpVerification(phonenumber);
                              if(otpVerificationResponce is ResponseClass)
                              {
                                if(otpVerificationResponce.responseCode == 200){
                                  otpTimer();
                                }else{
                                  setState(() {
                                    errorMessage = otpVerificationResponce.detailedMessage.toString();
                                  });
                                }
                              }
                              else{
                                setState(() {
                                  errorMessage = otpVerificationResponce.toString();
                                });
                              }
                            }
                            catch (e){
                              setState(() {
                                errorMessage = e.toString();
                              });
                            }
                          }
                        },
                        child: Text("RESEND NEW CODE",textAlign: TextAlign.center,style: TextStyle(fontFamily: "SourceSanProBold",fontSize:screenheight > ThemeClass.lowReslutionDevice ?  20 : 18,color: _isResendAgain ? ThemeClass.lightTextColor :ThemeClass.primaryColor))), //ThemeClass.primaryColor
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Image.asset(ThemeClass.poweredByIcon, height: 25,width: 100,fit: BoxFit.fill,),
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
      );
    }else
      {
        return Widgets.noInternetConnection(context,  () {
          setState(() {
            internetChecking = true;
          });
        },);
      }
  }


}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;
  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);
    String timerText = '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Text("OTP Expires in $timerText", style: const TextStyle(fontSize: 14, color: Colors.blueAccent,fontWeight: FontWeight.bold),);
  }
}