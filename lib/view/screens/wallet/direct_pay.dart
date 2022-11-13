import 'dart:async';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../Assistants/globals.dart';
import '../../../controller/location_controller.dart';
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
  final PaymentController walletController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [

            routes_color6,
            routes_color,
          ]
          )
      ),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
              children: [
                Positioned(
                    top: 0.0,
                    width: screenSize.width,

                    child: SizedBox(
                        height: screenSize.height*0.1+11.h,
                        width: screenSize.width.w,
                        child: Header(screenSize))),
               Positioned(
                  top:screenSize.height *0.1 +50.h,
                  left: 0.w,
                  width: screenSize.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      SizedBox(height: 16.h,),
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
                      SizedBox(height: 16.h,),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: DelayedDisplay(
                          child: Image.asset(
                            "${assetsDir}scanqrcode2.png",
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                     SizedBox(height: screenSize.height*0.1-30.h,),
                      // QR SCAN BUTTON
                      DelayedDisplay(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

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
                                scanQRCodeToPay(context,true);

                              } else {

                                showFlutterToast(message:"msg_0_balance",backgroundColor: Colors.redAccent,textColor: Colors.white);
                              }
                            }, label: Text(
                              "Pay via scan QR code_txt".tr,
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold

                              ),
                            ), icon: Icon(Icons.qr_code), ),
                            SizedBox(width:screenSize.width *0.1-26.w,),
                            OutlinedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(routes_color),
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12,horizontal: 6)),
                              ) ,
                              onPressed: ()async{
                                //String codeDate = DateFormat('yyyy-MM-dd-HH:mm-ss').format(DateTime.now());
                                //EncryptionData encrypt = EncryptionData();
                                //encrypt.encryptAES("{\"lastToken\":\"${prefs.getString('lastToken')}\",\"paymentCode\":\"$codeDate${prefs.getString('lastPhone')!}\",\"userName\":\"${prefs.getString('userName')!}\"}");
                                String balance = await checkWallet();
                                double balanceNum = double.parse(balance);
                                String? code ;
                                if(balanceNum>0.200){
                                  code =await paymentController.getEncryptedCode();
                                  Get.dialog(Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                      ),
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        height:380.h,
                                        color: Colors.white,
                                        child: Center(
                                          child: QrImage(
                                            data: "${code}",
                                            version: QrVersions.auto,
                                            size: 322.0.sp,
                                          ),
                                        ),
                                      )
                                  ));
                                }else{
                                  showFlutterToast(message:"msg_0_balance",backgroundColor: Colors.redAccent,textColor: Colors.white);
                                }


                              //print("{\"lastToken\":\"${prefs.getString('lastToken')}\",\"paymentCode\":\"$codeDate${prefs.getString('lastPhone')!}\",\"userName\":\"${prefs.getString('userName')!}\"}");
                            }, icon: Icon(Icons.qr_code),
                            label:Text(
                              "Pay via show QR code_txt".tr,
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  letterSpacing: 0,
                                fontWeight: FontWeight.bold
                              ),
                            ), ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h,)
                    ],
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }

  Future<String> checkWallet() async{
    await paymentController.getMyWallet();
    return paymentController.myBalance.value;
  }

}

