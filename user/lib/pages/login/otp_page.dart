import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/booking_confirmation.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/invoice.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/login/get_started.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';
import '../../styles/styles.dart';
import '../../functions/functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'enter_phone_number.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String otpNumber = ''; //otp number
  List otpText = []; //otp number as list for 6 boxes
  List otpPattern = [1, 2, 3, 4, 5, 6]; //list to create number of input box
  var resendTime = 60; //otp resend time
  late Timer timer; //timer for resend time
  String _error =
      ''; //otp error string to show if error occurs in otp validation
  TextEditingController otpController =
      TextEditingController(); //otp textediting controller
  TextEditingController first = TextEditingController();
  TextEditingController second = TextEditingController();
  TextEditingController third = TextEditingController();
  TextEditingController fourth = TextEditingController();
  TextEditingController fifth = TextEditingController();
  TextEditingController sixth = TextEditingController();
  late List<TextEditingController?> controller;
  bool _loading = false;
  bool buttonLoading = false;
//loading screen showing
  @override
  void initState() {
    _loading = false;
    timers();
    otpFalse();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel;
    super.dispose();
  }

  //navigate
  navigate(verify) {
    if (verify == true) {
      if (userRequestData.isNotEmpty && userRequestData['is_completed'] == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Invoice()),
            (route) => false);
      } else if (userRequestData.isNotEmpty &&
          userRequestData['is_completed'] != 1) {
        Future.delayed(const Duration(seconds: 2), () {
          if (userRequestData['is_rental'] == true) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingConfirmation(
                          type: 1,
                        )),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BookingConfirmation()),
                (route) => false);
          }
        });
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Maps()),
            (route) => false);
      }
    }  else if(verify == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const GetStarted()));
    } else {
      _error = verify.toString();
      setState(() {
        _loading = false;
      });
    }
  }

  //otp is false
  otpFalse() async {
    if (phoneAuthCheck == false) {
      _loading = true;
     // otpController.text = '123456';
      otpNumber = otpController.text;
      var verify = await verifyUser(phnumber);

      navigate(verify);
    }
  }

  //auto verify otp

  verifyOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credentials);

      var verify = await verifyUser(phnumber);
      navigate(verify);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-verification-code') {
        setState(() {
          otpController.clear();
          otpNumber = '';
          _error = languages[choosenLanguage]['text_otp_error'];
        });
      }
    }
  }

// running resend otp timer
  timers() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTime != 0) {
        if (mounted) {
          setState(() {
            resendTime--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              if (credentials != null) {
                _loading = true;
                verifyOtp();
              }
              return Scaffold(
                body: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: media.width * 0.08, right: media.width * 0.08,
                            top: media.width * 0.05 +
                                MediaQuery.of(context).padding.top
                        ),
                        color: page,
                        height: media.height * 1,
                        width: media.width * 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: media.width * 1,
                                color: topBar,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons.arrow_back_ios),
                                            Text('BACK', style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16.0
                                            ),)
                                          ],
                                        )),
                                  ],
                                )),
                            SizedBox(height: 50,),
                         //   Image.asset('assets/animated_images/verify_number.png', width: 300,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: media.height * 0.04,
                                  ),
                                  SizedBox(
                                    width: media.width * 1,
                                    child: Text(
                                      languages[choosenLanguage]
                                          ['text_phone_verify'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * twentyeight,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      languages[choosenLanguage]['text_enter_otp'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen,
                                          color: textColor.withOpacity(0.3)),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    countries[phcode]['dial_code'] + phnumber,
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                                  SizedBox(height: media.height * 0.05),

                                  //otp text box
                                  OtpTextField(
                                    numberOfFields: 6,
                                    borderColor: Color(0xFF512DA8),
                                    focusedBorderColor: buttonColor,
                                             borderRadius: BorderRadius.circular(16.0),
                                    enabledBorderColor: buttonColor,
                                    // orderRadius: BorderRadius.circular(16.0),
                                    // benabledBorderColor: buttonColor,
                                    disabledBorderColor: buttonColor,
                                    // clearText: clearText,
                                    showFieldAsBox: true,
                                    // textStyle: theme.textTheme.subtitle1,
                                    onCodeChanged: (String value) {
                                      //Handle each value
                                      print(otpController);
                                    },
                                    handleControllers: (controllers) {
                                      //get all textFields controller, if needed
                                      controller = controllers;
                                    },
                                    onSubmit: (String verificationCode) {
                                      //set clear text to clear text from all fields
                                      setState(() {
                                        print(verificationCode);
                                        otpNumber = verificationCode;
                                      });
                                    }, // end onSubmit
                                  ),
                                  // Container(
                                  //   height: media.width * 0.15,
                                  //   width: media.width * 0.9,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(12),
                                  //       color: page,
                                  //       border: Border.all(
                                  //           color: borderLines, width: 1.2)),
                                  //   child: TextField(
                                  //     controller: otpController,
                                  //     autofocus:
                                  //         (phoneAuthCheck == false) ? false : true,
                                  //     onChanged: (val) {
                                  //       setState(() {
                                  //         otpNumber = val;
                                  //       });
                                  //       if (val.length == 6) {
                                  //         FocusManager.instance.primaryFocus
                                  //             ?.unfocus();
                                  //       }
                                  //     },
                                  //     decoration: InputDecoration(
                                  //         border: InputBorder.none,
                                  //         counterText: '',
                                  //         hintText: languages[choosenLanguage]
                                  //             ['text_enter_otp_login']),
                                  //     textAlign: TextAlign.center,
                                  //     style: GoogleFonts.roboto(
                                  //       fontSize: media.width * twenty,
                                  //       color: textColor,
                                  //       fontWeight: FontWeight.w600,
                                  //     ),
                                  //     maxLength: 6,
                                  //     keyboardType: TextInputType.number,
                                  //   ),
                                  // ),

                                  //otp error
                                  (_error != '')
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              top: media.height * 0.02),
                                          child: Text(
                                            _error,
                                            style: GoogleFonts.roboto(
                                                fontSize: media.width * sixteen,
                                                color: Colors.red),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: media.height * 0.05,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: buttonLoading ? LoadingButton(onTap: null) : Button(
                                      onTap: () async {
                                        if (otpNumber.length == 6) {
                                          setState(() {
                                            buttonLoading = true;
                                            _error = '';
                                          });
                                          //firebase code send false
                                          if (phoneAuthCheck == false) {
                                            var verify = await verifyUser(phnumber);

                                            navigate(verify);
                                          } else {
                                            // firebase code send true
                                            try {
                                              PhoneAuthCredential credential =
                                                  PhoneAuthProvider.credential(
                                                      verificationId: verId,
                                                      smsCode: otpNumber);

                                              // Sign the user in (or link) with the credential
                                              await FirebaseAuth.instance
                                                  .signInWithCredential(credential);

                                              var verify = await verifyUser(phnumber);
                                              navigate(verify);
                                            } on FirebaseAuthException catch (error) {
                                              if (error.code ==
                                                  'invalid-verification-code') {
                                                setState(() {
                                                  otpController.clear();
                                                  otpNumber = '';
                                                  _error =
                                                      languages[choosenLanguage]
                                                          ['text_otp_error'];
                                                });
                                              }
                                            }
                                          }
                                          setState(() {
                                            buttonLoading = false;
                                          });
                                        } else if (phoneAuthCheck == true &&
                                            resendTime == 0 &&
                                            otpNumber.length != 6) {
                                          setState(() {
                                            setState(() {
                                              resendTime = 60;
                                            });
                                            timers();
                                          });
                                          phoneAuth(countries[phcode]['dial_code'] +
                                              phnumber);
                                        }
                                      },
                                      text: (otpNumber.length == 6)
                                          ? languages[choosenLanguage]
                                              ['text_verify']
                                          : (resendTime == 0)
                                              ? languages[choosenLanguage]
                                                  ['text_resend_code']
                                              : languages[choosenLanguage]
                                                      ['text_resend_code'] +
                                                  ' ' +
                                                  resendTime.toString(),
                                      color:
                                          (resendTime != 0 && otpNumber.length != 6)
                                              ? hideButtonColor
                                              : buttonColor,
                                      borcolor:
                                          (resendTime != 0 && otpNumber.length != 6)
                                              ? hideButtonColor
                                              : buttonColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      //no internet
                      (internet == false)
                          ? Positioned(
                              top: 0,
                              child: NoInternet(onTap: () {
                                setState(() {
                                  internetTrue();
                                });
                              }))
                          : Container(),

                      //loader
                      (_loading == true)
                          ? Positioned(
                              top: 0,
                              child: SizedBox(
                                height: media.height * 1,
                                width: media.width * 1,
                                child: const Loading(),
                              ))
                          : Container()
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}