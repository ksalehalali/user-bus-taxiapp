// QR Code Scanner
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import '../../Data/current_data.dart';
import '../../controller/payment_controller.dart';


Future<void> scanQRCodeToPay(BuildContext context,isDirectPay,int paymentType) async {
  final PaymentController paymentController = Get.find();

  try {
    final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#5fa693', "Cancel", true, ScanMode.QR);
    print(qrCode);
    final jsonData = jsonDecode(qrCode);

    if (jsonData != null) {
      tripToSave.busId = jsonData['busId'];
      paymentSaved.busId = jsonData['busId'];
      paymentSaved.routeId = jsonData['routeId'];
      paymentSaved.value = jsonData['value'];
      if(isDirectPay ==true){


        var pay = await paymentController.pay(true);
        if (pay == true) {
          print(pay);
        } else {
          print(pay);
        }

      }else{
        var pay = await paymentController.pay(false);
        if (pay == true) {
          print(pay);
        } else {
          print(pay);
        }
      }
    }

  } on PlatformException {
    Get.snackbar('Scan Failed', "Scan Failed try again");
  }
}