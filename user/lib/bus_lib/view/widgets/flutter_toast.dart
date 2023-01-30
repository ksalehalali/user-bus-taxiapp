

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void showFlutterToast({required String message, required Color backgroundColor, required Color textColor,required isLong}){
  Fluttertoast.showToast(
      msg: "${message}".tr,
      toastLength: isLong==true?Toast.LENGTH_LONG:Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0.sp);
}