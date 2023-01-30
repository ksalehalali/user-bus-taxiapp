import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tagyourtaxi_driver/bus_lib/view/screens/home/main_screen.dart';

import '../../../main.dart';
import '../../../pages/loadingPage/loadingpage.dart';
import '../../../pages/onTripPage/map_page.dart';
import '../../Assistants/globals.dart';

class Separator extends StatefulWidget {
  const Separator({Key? key}) : super(key: key);

  @override
  State<Separator> createState() => _SeparatorState();
}

class _SeparatorState extends State<Separator> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return  Container(
      color: Colors.red,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                routes_color2,
                routes_color,
              ]),
              color: Colors.white),
          child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    routes_color6,
                    routes_color,
                  ]),
                  color: Colors.white),
              child: Image.asset(
                'assets/animation/ROUTES-Animated Logo.gif',
                fit: BoxFit.fill,
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:  EdgeInsets.only(bottom:screenSize.height *0.1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Maps()));

                      },
                      style: ElevatedButton.styleFrom(
                          maximumSize: Size(
                              Get.size.width * 0.4.w, Get.size.width * 0.4.w),
                          minimumSize: Size(Get.size.width * 0.4.w, 40.w),
                          primary: routes_color2,
                          onPrimary: Colors.white,
                          alignment: Alignment.center),
                      child: Text(
                        "Go Taxi".tr,
                        style: TextStyle(fontSize: 17.sp, letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MainScreen(indexOfScreen: 0)));
                      },
                      style: ElevatedButton.styleFrom(
                          maximumSize: Size(
                              Get.size.width * 0.4.w, Get.size.width * 0.4.w),
                          minimumSize: Size(Get.size.width * 0.4.w, 40.w),
                          primary: routes_color2,
                          onPrimary: Colors.white,
                          alignment: Alignment.center),
                      child: Text(
                        "Go Bus".tr,
                        style: TextStyle(fontSize: 17.sp, letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
          ),
        ),
      ),
    );
  }
}
