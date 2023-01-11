import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loadingpage.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({Key? key}) : super(key: key);

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  bool _isLoading = true;
  bool _showToast = false;

  @override
  void initState() {
    print('ll');
    super.initState();
    _getReferral();

  }

//get referral code
  _getReferral() async {
    await getReferral();
    setState(() {
      _isLoading = false;
    });
  }

//show toast for copy
  showToast() {
    setState(() {
      _showToast = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showToast = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: ValueListenableBuilder(
          valueListenable: valueNotifierHome.value,
          builder: (context, value, child) {
            return Directionality(
              textDirection: (languageDirection == 'rtl')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: blueColor,
                    height: media.height,
                    width: media.width,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                  20,
                                ),
                                topLeft: Radius.circular(20),
                              ),
                            ),
                            height: media.height * 0.35,
                            width: media.width,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: media.height * 0.05,
                                ),
                                myReferralCode['referral_comission_string'].toString().length > 17
                                    ? Text(
                                  "${myReferralCode['referral_comission_string'].toString().substring(0, 18)}\n"
                                      "${myReferralCode['referral_comission_string'].toString().substring(18, 26)}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            fontSize: 20,
                                            color: black,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : Text('No Text'),
                                SizedBox(
                                  height: media.height * 0.02,
                                ),
                                Container(
                                    width: media.width * 0.9,
                                    padding: EdgeInsets.all(media.width * 0.05),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: borderLines, width: 1.2),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          myReferralCode['refferal_code'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * sixteen,
                                              color: textColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                Clipboard.setData(ClipboardData(
                                                    text: myReferralCode[
                                                        'refferal_code']));
                                              });
                                              //show toast for copy
                                              showToast();
                                            },
                                            child: const Icon(Icons.copy))
                                      ],
                                    )),
                                SizedBox(
                                  height: media.height * 0.03,
                                ),
                                SizedBox(
                                 height: media.height*0.08,
                                  width: media.width*0.9,
                                  child: Button(
                                      color: blueColor,
                                      onTap: () async {
                                        await Share.share(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            languages[choosenLanguage]
                                                        ['text_invitation_1']
                                                    .toString()
                                                    .replaceAll(
                                                        '55', package.appName) +
                                                ' ' +
                                                myReferralCode[
                                                    'refferal_code'] +
                                                ' ' +
                                                languages[choosenLanguage]
                                                    ['text_invitation_2']);
                                      },
                                      text: languages[choosenLanguage]
                                          ['text_invite']),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Image.asset(
                            'assets/animated_images/arrow.png',
                            height: media.height * 0.3,
                            width: media.width * 0.7,
                          ),
                        ),
                        Positioned(
                          child: SizedBox(
                            height: media.height * 0.15,
                            width: media.width,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: media.width * 0.05,
                                ),
                                SizedBox(
                                  width: media.width * 0.1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: media.height * 0.04),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: white,
                                        size: media.height * 0.04,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: media.width * 0.2,
                                ),
                                SizedBox(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: media.height * 0.05),
                                    child: Text(
                                      languages[choosenLanguage]
                                          ['text_enable_referal'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * twenty,
                                          fontWeight: FontWeight.w600,
                                          color: white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            top: media.height * 0.25,
                            left: 0,
                            right: 0,
                            child: Image.asset('assets/images/ref_image.png')),
                      ],
                    ),
                  ),
                  (internet == false)
                      ? Positioned(
                          top: 0,
                          child: NoInternet(
                            onTap: () {
                              setState(() {
                                internetTrue();
                                _isLoading = true;
                                getReferral();
                              });
                            },
                          ))
                      : Container(),

                  //loader
                  (_isLoading == true)
                      ? const Positioned(top: 0, child: Loading())
                      : Container(),

                  //display toast
                  (_showToast == true)
                      ? Positioned(
                          bottom: media.height * 0.2,
                          child: Container(
                            padding: EdgeInsets.all(media.width * 0.025),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent.withOpacity(0.6)),
                            child: Text(
                              languages[choosenLanguage]['text_code_copied'],
                              style: GoogleFonts.roboto(
                                  fontSize: media.width * twelve,
                                  color: Colors.white),
                            ),
                          ))
                      : Container()
                ],
              ),
            );
          }),
    );
  }
}