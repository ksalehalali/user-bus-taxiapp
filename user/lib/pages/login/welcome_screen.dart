import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/pages/login/enter_phone_number.dart';
import 'package:tagyourtaxi_driver/pages/login/get_started.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';

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
            color: primaryColor,
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
                                  primary: primaryColor,
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