import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:posibolt_loyality/themes/themeclass.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:posibolt_loyality/voucher/activevoucherscreen.dart';
import 'package:share_plus/share_plus.dart';

import '../SharedPrefrence/sharedPrefrence.dart';
class BarcodeDisplayScreen extends StatelessWidget {
  final String barcodeNumber;

  BarcodeDisplayScreen({super.key, required this.barcodeNumber});
  final GlobalKey _globalKey = GlobalKey();
  Future<void> _shareImage() async {
    try {
      // Capture the widget to an image
      SharedPreference sharedPreference = SharedPreference();
      String name = sharedPreference.getLoyaltyUsersName().toString();

      RenderRepaintBoundary boundary =
      _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Save image to a temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/voucher.png').create();
      await file.writeAsBytes(pngBytes);

      // Share the image using share_plus
      Share.shareXFiles([XFile(file.path)], text: 'Here is your voucher from $name! Show this voucher barcode at counter to redeem .');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(title: Text('Voucher Details'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => ActiveVoucherScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareImage,
          ),
        ],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  color: Colors.white,

                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          //color: Colors.grey[100], // Background color of the box
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2, // Border width
                          ),
                        ),
                        child: Row(

                          children: [
                            Text(
                              'Voucher No: $barcodeNumber',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87, // Text color
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          //color: Colors.grey[100], // Background color of the box
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2, // Border width
                          ),
                        ),
                        child: BarcodeWidget(
                          data: barcodeNumber,
                          barcode: Barcode.code128(
                              useCode128B: true),
                          //  width: 200,
                          height: 120,
                        ),
                      ),
                    ],
                  ),
                ),
              ),



              SizedBox(height: 40),
              Text(
                'Steps to redeem voucher',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              buildStep('Step 1', 'Complete your shopping at the  Store',"assets/images/online-shopping.png"),
              buildStep('Step 2', 'Visit the Cash Counter to make payment',"assets/images/cash-counter.png"),
              buildStep('Step 3', 'Inform the cashier about the  App Show your voucher barcode to the cashier',"assets/images/mobile-payment.png"),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildStep(String step, String description,String path) {
    return ListTile(
      leading:     Image.asset(
       path,
        width: 40,
        height: 40,
      ),
      title: Text(step, style: const TextStyle(
        color: ThemeClass.primaryColor,
      ),),
      subtitle: Text(description),
    );
  }
}
