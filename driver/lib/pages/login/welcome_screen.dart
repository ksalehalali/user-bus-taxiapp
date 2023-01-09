import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/pages/login/get_started.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';
import 'package:tagyourtaxi_driver/pages/login/signup.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import 'enter_phone_number.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: white,
        body: Container(
            height: height,
            width: width,
            color: blueColor,
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: Image.asset(
                    'assets/animated_images/arrow.png',
                    height: height * 0.3,
                    width:width * 0.7,
                  ),
                ),
                Positioned(
                  child: SizedBox(
                    height: height * 0.15,
                    width: width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.05,
                        ),
                        SizedBox(
                          width: width * 0.1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.04),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: white,
                                size: height * 0.04,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.2,
                        ),
                        // SizedBox(
                        //   child: Padding(
                        //     padding: EdgeInsets.only(
                        //         top: height * 0.05),
                        //     child: Text(
                        //       languages[choosenLanguage]
                        //       ['text_enable_referal'],
                        //       style: GoogleFonts.roboto(
                        //           fontSize: width * twenty,
                        //           fontWeight: FontWeight.w600,
                        //           color: white),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: height * 0.23,
                    left: 0,
                    right: 0,
                    child: Image.asset('assets/images/routes_white_logo.png',height: height*0.3,)),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: height * 0.3,
                    width: width,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          20,
                        ),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.05,
                          ),
                          SizedBox(
                            height: height * 0.05,
                            child: Text(
                              languages[choosenLanguage]['text_welcome'],
                              style: TextStyle(color: black,fontSize: 24,fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(height: height*0.02,),
                          SizedBox(
                            height: height * 0.03,
                            child: Text(
                              languages[choosenLanguage]['text_welcome_line_one'],
                              style: TextStyle(color: sub_text_color,fontSize: 15,fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                            child: Text(
                              languages[choosenLanguage]['text_welcome_line_two'],
                              style: TextStyle(color: sub_text_color,fontSize: 15,fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(height: height*0.03,),
                          SizedBox(height: height*0.07,width: width*0.85,child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: blueColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(36.0))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EnterPhoneNumber()));
                              },
                              child: Text(
                                languages[choosenLanguage]['text_login'],
                                style: TextStyle(fontSize: 18.0),
                              )),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}

class MyScreen extends StatelessWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/animated_images/welcome.png',
              width: MediaQuery.of(context).size.width / 2.5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                      color: black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Please Login to enter the exciting',
                  style: TextStyle(color: light_grey, fontSize: 16.0),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'world of ride.',
                  style: TextStyle(color: light_grey, fontSize: 16.0),
                ),
              ],
            ),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width / 2.5,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: notUploadedColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36.0))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EnterPhoneNumber()));
                  },
                  child: Text(
                    languages[choosenLanguage]['text_login'],
                    style: TextStyle(fontSize: 18.0),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
