import 'dart:async';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Assistants/globals.dart';
import '../../../controller/location_controller.dart';
import '../../../controller/packages_controller.dart';
import '../../../controller/payment_controller.dart';
import '../../widgets/QRCodeScanner.dart';
import '../../widgets/flutter_toast.dart';
import '../../widgets/headerDesgin.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class DirectPay extends StatefulWidget {
  @override
  State<DirectPay> createState() => _DirectPayState();
}

class _DirectPayState extends State<DirectPay> {
  final PaymentController paymentController = Get.find();
  final LocationController locationController = Get.find();
  final PackagesController packagesController = Get.find();
  bool askForQRCode = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future showQRCodeToPay(bool payByWallet)async{
    askForQRCode =true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String codeDate = DateFormat('yyyy-MM-dd-HH:mm-ss').format(DateTime.now());

    String balance = await checkWallet();
    double balanceNum = double.parse(balance);
    String? code;
    if (balanceNum > 0.200) {
      code = await paymentController.getEncryptedCode(0);
      Get.dialog(Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              15.0,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 380.h,
            color: Colors.white,
            child: Center(
              child: QrImage(
                data:code!,
                //"{\"lastToken\":\"${prefs.getString('lastToken')}\",\"paymentCode\":\"$codeDate${prefs.getString('lastPhone')!}\",\"userName\":\"${prefs.getString('userName')!}\"}",
                version: QrVersions.auto,
                size: 322.0.sp,
              ),
            ),
          )));
      askForQRCode = false;
    } else {
      showFlutterToast(
          message: "msg_0_balance",
          backgroundColor: Colors.redAccent,
          isLong: true,
          textColor: Colors.white);
      askForQRCode = false;

    }

    //print("{\"lastToken\":\"${prefs.getString('lastToken')}\",\"paymentCode\":\"$codeDate${prefs.getString('lastPhone')!}\",\"userName\":\"${prefs.getString('userName')!}\"}");
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        routes_color6,
        routes_color,
      ])),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Positioned(
                  top: 0.0,
                  width: screenSize.width,
                  child: SizedBox(
                      height: screenSize.height * 0.1 + 11.h,
                      width: screenSize.width.w,
                      child: Header(screenSize))),
              Positioned(
                top: screenSize.height * 0.1 + 50.h,
                left: 0.w,
                width: screenSize.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 22.0.h),
                      child: Text(
                        "start_pay_txt".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: DelayedDisplay(
                        child: Image.asset(
                          "${assetsDir}scanqrcode2.png",
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.1 - 30.h,
                    ),
                    // QR SCAN BUTTON
                    DelayedDisplay(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          //scan to pay button
                          packagesController.hasAPackage.value == true ?CupertinoContextMenu(
                              actions: <Widget>[
                                CupertinoContextMenuAction(
                                  child: Text(
                                    "Use Wallet_txt".tr,
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    String balance = await checkWallet();
                                    double balanceNum = double.parse(balance);

                                    if (balanceNum >= 0.200) {
                                      paymentController.ticketPayed.value =
                                          false;
                                      scanQRCodeToPay(context, true, 1);
                                    } else {
                                      showFlutterToast(
                                          message: "msg_0_balance",
                                          isLong: true,
                                          backgroundColor: Colors.redAccent,
                                          textColor: Colors.white);
                                    }
                                  },
                                ),
                                CupertinoContextMenuAction(
                                  child: Text(
                                    "Use Package_txt".tr,
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    paymentController.ticketPayed.value = false;
                                    scanQRCodeToPay(context, true, 1);
                                  },
                                )
                              ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white,
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.green,
                                      width: 0.4,
                                    ),
                                    right: BorderSide(
                                      color: Colors.green,
                                      width: 0.4,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.green,
                                      width: 0.4,
                                    ),
                                    top: BorderSide(
                                      color: Colors.green,
                                      width: 0.4,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top:9.0,bottom:9,right:2,left:2),
                                  child: Text(
                                    "Pay via scan QR code_txt".tr,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 15.sp,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ),
                              )):
                          OutlinedButton.icon(
                            style: ButtonStyle(
                              backgroundColor:MaterialStateProperty.all(Colors.white),
                              foregroundColor: MaterialStateProperty.all(routes_color),
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12.h,horizontal: 6.w)),

                            ) ,
                            onPressed: ()async{
                            String balance = await checkWallet();
                            double balanceNum = double.parse(balance);

                            if(balanceNum >= 0.200) {
                              paymentController.ticketPayed.value = false;
                              scanQRCodeToPay(context,true,0);

                            } else {

                              showFlutterToast(message:"msg_0_balance",backgroundColor: Colors.redAccent,textColor: Colors.white,isLong: true,
                              );
                            }
                          }, label: Text(
                            "Pay via scan QR code_txt".tr,
                            style: TextStyle(
                                fontSize: 13.sp,
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold

                            ),
                          ), icon: Icon(Icons.qr_code), ),
                          SizedBox(
                            width: screenSize.width * 0.1 - 26.w,
                          ),

                          //scan to pay button
                          packagesController.hasAPackage.value == true ? CupertinoContextMenu(
                              actions: <Widget>[
                                CupertinoContextMenuAction(
                                  child: Text(
                                    "Use Wallet_txt".tr,
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                   if (!askForQRCode){
                                     showQRCodeToPay(true);
                                   }else{
                                     showFlutterToast(
                                         message: "Please wait!",
                                         backgroundColor: Colors.redAccent,
                                         isLong: false,

                                         textColor: Colors.white);
                                   }

                                  },
                                ),
                                CupertinoContextMenuAction(
                                  child: Text(
                                    "Use Package_txt".tr,
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async{
                                    if (!askForQRCode){
                                      showQRCodeToPay(false);
                                    }else{
                                      showFlutterToast(
                                          message: "Please wait!",
                                          backgroundColor: Colors.redAccent,
                                          isLong: false,

                                          textColor: Colors.white);
                                    }
                                  },
                                )
                              ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white,
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.green,
                                      width: 0.4,
                                    ),
                                    right: BorderSide(
                                      color: Colors.green,
                                      width: 0.4,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.green,
                                      width: 0.4,
                                    ),
                                    top: BorderSide(
                                      color: Colors.green,
                                      width: 0.4,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top:9.0,bottom:9,right:2,left:2),
                                  child: Text(
                                      "Pay via show QR code_txt".tr,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 15.sp,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ),
                              )):

                          OutlinedButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              foregroundColor:
                                  MaterialStateProperty.all(routes_color),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 6)),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String codeDate =
                                  DateFormat('yyyy-MM-dd-HH:mm-ss')
                                      .format(DateTime.now());
                              //String codeDate = DateFormat('yyyy-MM-dd-HH:mm-ss').format(DateTime.now());
                              String balance = await checkWallet();
                              double balanceNum = double.parse(balance);
                              String? code;
                              if (balanceNum > 0.200) {
                                code =
                                    await paymentController.getEncryptedCode(1);
                                Get.dialog(Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        15.0,
                                      ),
                                    ),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      height: 380.h,
                                      color: Colors.white,
                                      child: Center(
                                        child: QrImage(
                                          data:code!,
                                         // data: "{\"lastToken\":\"${prefs.getString('lastToken')}\",\"paymentCode\":\"$codeDate${prefs.getString('lastPhone')!}\",\"userName\":\"${prefs.getString('userName')!}\"}",
                                          version: QrVersions.auto,
                                          size: 322.0.sp,
                                        ),
                                      ),
                                    )));
                              } else {
                                showFlutterToast(
                                    message: "msg_0_balance",
                                    isLong: true,
                                    backgroundColor: Colors.redAccent,
                                    textColor: Colors.white);
                              }

                              //print("{\"lastToken\":\"${prefs.getString('lastToken')}\",\"paymentCode\":\"$codeDate${prefs.getString('lastPhone')!}\",\"userName\":\"${prefs.getString('userName')!}\"}");
                            },
                            icon: Icon(Icons.qr_code),
                            label: Text(
                              "Pay via show QR code_txt".tr,
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> checkWallet() async {
    await paymentController.getMyWallet();
    return paymentController.myBalance.value;
  }
}
