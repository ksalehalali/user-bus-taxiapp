import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/login/get_started.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';
import 'package:tagyourtaxi_driver/pages/login/ownerregister.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/pages/vehicleInformations/docs_onprocess.dart';
import 'package:tagyourtaxi_driver/pages/vehicleInformations/upload_docs.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';
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
  String _error = ''; //otp error string to show if error occurs in otp validation
  TextEditingController otpController = TextEditingController(); //otp textediting controller
  TextEditingController first = TextEditingController();
  TextEditingController second = TextEditingController();
  TextEditingController third = TextEditingController();
  TextEditingController fourth = TextEditingController();
  TextEditingController fifth = TextEditingController();
  TextEditingController sixth = TextEditingController();
  late List<TextEditingController?> controls;

  int numberOfFields = 6;
  bool buttonLoading = false;
  var otpCode = "";
  bool _loading = false;
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
      if (userDetails['uploaded_document'] == false) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Docs()), (route) => false);
      } else if (userDetails['uploaded_document'] == true &&
          userDetails['approve'] == false) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const DocsProcess(),
            ),
            (route) => false);
      } else if (userDetails['uploaded_document'] == true &&
          userDetails['approve'] == true) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Maps()),
            (route) => false);
      }
    } else if (verify == false) {
      if (ischeckownerordriver == 'driver') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const GetStarted()));
      } else if (ischeckownerordriver == 'owner') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const OwnersRegister()));
      }
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
      otpController.text = '123456';
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
      credentials = null;
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
                            left: media.width * 0.08,
                            right: media.width * 0.08,
                            top: media.width * 0.05 +
                                MediaQuery.of(context).padding.top),
                        color: page,
                        height: media.height * 1,
                        width: media.width * 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            // Image.asset('assets/animated_images/verify_number.png', width: 300,),
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
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * twentyeight,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    languages[choosenLanguage]['text_enter_otp'],
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: textColor.withOpacity(0.3)),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "+"+countries[phcode]['dial_code'].toString() + phnumber,
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                                  SizedBox(height: media.height * 0.05),
                                  OtpTextField(
                                    numberOfFields: numberOfFields,
                                    borderColor: Color(0xFF512DA8),
                                    focusedBorderColor: primaryColor,
                                    borderRadius: BorderRadius.circular(16.0),
                                    enabledBorderColor: primaryColor,
                                    disabledBorderColor: primaryColor,
                                    // clearText: clearText,
                                    showFieldAsBox: true,
                                    // textStyle: theme.textTheme.subtitle1,
                                    onCodeChanged: (String value) {
                                      //Handle each value
                                      print(controls);
                                    },
                                    handleControllers: (controllers) {
                                      //get all textFields controller, if needed
                                      controls = controllers;
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
                                  //   height: media.height / 14,
                                  //   width: media.width / 1,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(12),
                                  //       color: page,
                                  //       border: Border.all(color: primaryColor, width: 1.2)
                                  //   ),
                                  //   child: TextField(
                                  //     controller: otpController,
                                  //     autofocus: (phoneAuthCheck == false) ? false : true,
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
                                  //             ['text_enter_otp_login']
                                  //     ),
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

                                  // show error on otp
                                  (_error != '')
                                      ? Container(
                                          width: media.width * 0.8,
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
                                          timer.cancel();
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
                                                  buttonLoading = false;
                                                });
                                              }
                                            }
                                          }
                                        } else if (phoneAuthCheck == true &&
                                            resendTime == 0 &&
                                            otpNumber.length != 6) {
                                          setState(() {
                                            setState(() {
                                              resendTime = 60;
                                            });
                                            timers();
                                          });
                                          phoneAuth("+${countries[phcode]['dial_code']}$phnumber");
                                        }
                                      },
                                      borcolor: (resendTime != 0 && otpNumber.length != 6)
                                              ? secondaryColor
                                              : null,
                                      text: (otpNumber.length == 6)
                                          ? languages[choosenLanguage]['text_verify']
                                          : (resendTime == 0)
                                              ? languages[choosenLanguage]['text_resend_code']
                                              : languages[choosenLanguage]['text_resend_code'] + ' ' + resendTime.toString(),
                                      color: (resendTime != 0 && otpNumber.length != 6)
                                              ? hideButtonColor
                                              : primaryColor,
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
                              child: NoInternet(
                                onTap: () {
                                  setState(() {
                                    internetTrue();
                                  });
                                },
                              ))
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
