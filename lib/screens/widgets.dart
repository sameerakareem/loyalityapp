import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Widgets {
  static Widget noInternetConnection(BuildContext context, VoidCallback onNetworkAvailable) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool internetChecking = false;

        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/no_internet_connection.svg",
                  height: MediaQuery.of(context).size.height * 0.1,
                  color: const Color(0xffDB283E),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "No connection!",
                  style: TextStyle(
                    fontFamily: "SourceSanProBold",
                    fontSize: 28,
                    color: Color(0xff383838),
                  ),
                ),
                const SizedBox(height: 15.0),
                const Text(
                  "Please check your internet connectivity\nand try again",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "inter",
                    fontSize: 15,
                    color: Color(0xff818181),
                  ),
                ),
                const SizedBox(height: 30.0),
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.055,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Check for internet connection
                        bool connection = await InternetConnectionChecker().hasConnection;
                        setState(() {
                          internetChecking = connection;
                        });

                        if (internetChecking) {
                          onNetworkAvailable(); // Notify the ProfileScreen to update its state
                         // Navigator.pop(context); // Close the noInternetConnection screen
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No internet connection. Please try again.')),
                          );
                        }
                      },
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: Color(0xfff2f2f2),
                          fontFamily: 'SourceSansPro',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffDB283E),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
