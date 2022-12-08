import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../noInternet/nointernet.dart';
import 'get_started.dart';
import 'otp_page.dart';

class EnterPhoneNumber extends StatefulWidget {
  const EnterPhoneNumber({Key? key}) : super(key: key);

  @override
  State<EnterPhoneNumber> createState() => _EnterPhoneNumberState();
}

String phnumber = ''; // phone number as string entered in input field

class _EnterPhoneNumberState extends State<EnterPhoneNumber> {
  TextEditingController controller = TextEditingController();

  bool _isLoading = true;

  bool terms = true; //terms and conditions true or false

  @override
  void initState() {
    countryCode();
    super.initState();
  }

  //navigate
  navigate() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Otp()));
  }

  countryCode() async {
    var result = await getCountryCode();
    if (result == 'success') {
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      color: Colors.white,
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                (countries.isNotEmpty)
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(height: 10,),
                        // SafeArea(
                        //   child: Padding(
                        //     padding: EdgeInsets.only(left: 20),
                        //     child: Align(
                        //       alignment: Alignment.centerLeft,
                        //       child: Text(languages[choosenLanguage]['text_login'],
                        //         style: TextStyle(color: buttonColor, fontSize: 18.0, fontWeight: FontWeight.w700),),
                        //     ),
                        //   ),
                        // ),
                        Image.asset('assets/animated_images/enter_phone.png', width: 350,),
                        Text('Enter Your Phone Number', style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w800),),
                        SizedBox(height: media.height * 0.01),
                        Text('Create an account',
                          style: TextStyle(fontSize: 20.0, color: light_grey),),
                        SizedBox(height: media.height * 0.04),
                        Container(
                          padding: const EdgeInsets.only(bottom: 5, left: 7),
                          height: 55,
                          width: media.width * 1 - (media.width * 0.08 * 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: light_grey),
                            borderRadius: BorderRadius.circular(24.0),
                            // border: Border(bottom: BorderSide(color: underline))),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (countries.isNotEmpty) {
                                    //dialod box for select country for dial code
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          var searchVal = '';
                                          return AlertDialog(
                                            insetPadding:
                                            const EdgeInsets.all(10),
                                            content: StatefulBuilder(
                                                builder: (context, setState) {
                                                  return Container(
                                                    width: media.width * 0.9,
                                                    color: Colors.white,
                                                    child: Directionality(
                                                      textDirection:
                                                      (languageDirection ==
                                                          'rtl')
                                                          ? TextDirection.rtl
                                                          : TextDirection.ltr,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 20,
                                                                right: 20),
                                                            height: 40,
                                                            width:
                                                            media.width * 0.9,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    20),
                                                                border: Border.all(
                                                                    color:
                                                                    Colors.grey,
                                                                    width: 1.5)),
                                                            child: TextField(
                                                              decoration: InputDecoration(
                                                                  contentPadding: (languageDirection ==
                                                                      'rtl')
                                                                      ? EdgeInsets.only(
                                                                      bottom: media.width *
                                                                          0.035)
                                                                      : EdgeInsets.only(
                                                                      bottom: media.width *
                                                                          0.04),
                                                                  border: InputBorder
                                                                      .none,
                                                                  hintText:
                                                                  languages[choosenLanguage]
                                                                  [
                                                                  'text_search'],
                                                                  hintStyle: GoogleFonts.roboto(
                                                                      fontSize: media
                                                                          .width *
                                                                          sixteen)),
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  searchVal = val;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 20),
                                                          Expanded(
                                                            child:
                                                            SingleChildScrollView(
                                                              child: Column(
                                                                children: countries
                                                                    .asMap()
                                                                    .map(
                                                                        (i, value) {
                                                                      return MapEntry(
                                                                          i,
                                                                          SizedBox(
                                                                            width: media.width *
                                                                                0.9,
                                                                            child: (searchVal == '' &&
                                                                                countries[i]['flag'] != null)
                                                                                ? InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    phcode = i;
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                  color: Colors.white,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Image.network(countries[i]['flag']),
                                                                                          SizedBox(
                                                                                            width: media.width * 0.02,
                                                                                          ),
                                                                                          SizedBox(
                                                                                              width: media.width * 0.4,
                                                                                              child: Text(
                                                                                                countries[i]['name'],
                                                                                                style: GoogleFonts.roboto(fontSize: media.width * sixteen),
                                                                                              )),
                                                                                        ],
                                                                                      ),
                                                                                      Text(
                                                                                        countries[i]['dial_code'],
                                                                                        style: GoogleFonts.roboto(fontSize: media.width * sixteen),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ))
                                                                                : (countries[i]['flag'] != null && countries[i]['name'].toLowerCase().contains(searchVal.toLowerCase()))
                                                                                ? InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    phcode = i;
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                  color: Colors.white,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Image.network(countries[i]['flag']),
                                                                                          SizedBox(
                                                                                            width: media.width * 0.02,
                                                                                          ),
                                                                                          SizedBox(
                                                                                              width: media.width * 0.4,
                                                                                              child: Text(
                                                                                                countries[i]['name'],
                                                                                                style: GoogleFonts.roboto(fontSize: media.width * sixteen),
                                                                                              )),
                                                                                        ],
                                                                                      ),
                                                                                      Text(
                                                                                        countries[i]['dial_code'],
                                                                                        style: GoogleFonts.roboto(fontSize: media.width * sixteen),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ))
                                                                                : Container(),
                                                                          ));
                                                                    })
                                                                    .values
                                                                    .toList(),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          );
                                        });
                                  } else {
                                    getCountryCode();
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Image.network(countries[phcode]['flag']),
                                      SizedBox(
                                        width: media.width * 0.02,
                                      ),
                                      Text(
                                        countries[phcode]['dial_code']
                                            .toString(),
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * sixteen,
                                            color: textColor),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      const Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 1,
                                height: media.width * 0.0693,
                                color: buttonColor,
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                width: media.width * 0.5,
                                child: TextFormField(
                                  controller: controller,
                                  onChanged: (val) {
                                    setState(() {
                                      phnumber = controller.text;
                                    });
                                    if (controller.text.length ==
                                        countries[phcode]['dial_max_length']) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    }
                                  },
                                  maxLength: countries[phcode]
                                  ['dial_max_length'],
                                  style: GoogleFonts.roboto(
                                      fontSize: media.width * sixteen,
                                      color: textColor,
                                      letterSpacing: 1),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: languages[choosenLanguage]
                                    ['text_phone_number'],
                                    counterText: '',
                                    hintStyle: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: textColor.withOpacity(0.7)),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: media.height * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (terms == true) {
                                    terms = false;
                                  } else {
                                    terms = true;
                                  }
                                });
                              },
                              child: Container(
                                  height: media.width * 0.08,
                                  width: media.width * 0.08,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: buttonColor, width: 2),
                                      shape: BoxShape.circle,
                                      color:
                                      (terms == true) ? buttonColor : page),
                                  child: const Icon(Icons.done,
                                      color: Colors.white)),
                            ),
                            SizedBox(
                              width: media.width * 0.02,
                            ),
                            SizedBox(
                              width: media.width * 0.7,
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Text(
                                    languages[choosenLanguage]['text_agree'] +
                                        ' ',
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: textColor.withOpacity(0.7)),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      openBrowser(
                                          'terms and conditions url');
                                    },
                                    child: Text(
                                      languages[choosenLanguage]['text_terms'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen,
                                          color: buttonColor),
                                    ),
                                  ),
                                  Text(
                                    ' ${languages[choosenLanguage]['text_and']} ',
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: textColor.withOpacity(0.7)),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      openBrowser(
                                          'privacy policy url');
                                    },
                                    child: Text(
                                      languages[choosenLanguage]
                                      ['text_privacy'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen,
                                          color: buttonColor),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: media.height * 0.06,
                        ),
                        (controller.text.length >=
                            countries[phcode]['dial_min_length'] &&
                            terms == true)
                            ? Container(
                          width: media.width * 1 - media.width * 0.08,
                          alignment: Alignment.center,
                          child: Button(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                _isLoading = true;
                              });
                              //check if otp is true or false
                              var val = await otpCall();
                              //otp is true
                              if (val.value == true) {
                                phoneAuthCheck = true;
                                await phoneAuth(countries[phcode]['dial_code'] + phnumber);

                                navigate();
                              }
                              //otp is false
                              else if (val.value == false) {
                                phoneAuthCheck = false;
                                navigate();
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            text: languages[choosenLanguage]
                            ['text_login'],
                          ),
                        )
                            : Container(),
                      ],
                    )
                    : Container(
                  height: media.height * 1,
                  width: media.width * 1,
                  color: page,
                ),

                //loader
                (_isLoading == true)
                    ? const Positioned(top: 0, child: Loading())
                    : Container(),
                //no internet
                (internet == false)
                    ? Positioned(
                    top: 0,
                    child: NoInternet(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                          internet = true;
                          countryCode();
                        });
                      },
                    ))
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}