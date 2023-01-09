import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';
import '../../functions/functions.dart';
import '../../widgets/widgets.dart';
import '../login/driver_or_owner.dart';
import '../login/welcome_screen.dart';
import '../onTripPage/map_page.dart';

class Languages extends StatefulWidget {
  var fromMenu;

  Languages(this.fromMenu, {Key? key}) : super(key: key);

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  bool _isLoading = false;

  @override
  void initState() {
    choosenLanguage = 'en';
    languageDirection = 'ltr';
    super.initState();
  }

  navigate() {
    if (widget.fromMenu) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Maps()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Container(
          color: blueColor,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: media.height * 0.3,
                  width: media.width,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(children: [
                    SizedBox(height: media.height*0.03,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: media.width*0.06),
                      child: Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children:
                            languages
                                .map(
                                  (i, value) => MapEntry(
                                i,
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      choosenLanguage = i;
                                      if (choosenLanguage == 'ar' ||
                                          choosenLanguage == 'ur' ||
                                          choosenLanguage == 'iw') {
                                        languageDirection = 'rtl';
                                      } else {
                                        languageDirection = 'ltr';
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(media.width * 0.025),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesCode
                                                  .firstWhere((e) => e['code'] == i)['name']
                                                  .toString(),
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width * sixteen,
                                                  color: textColor),
                                            ),
                                            Container(
                                              height: media.width * 0.05,
                                              width: media.width * 0.05,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: const Color(0xff222222),
                                                      width: 1.2)),
                                              alignment: Alignment.center,
                                              child: (choosenLanguage == i)
                                                  ? Container(
                                                height: media.width * 0.03,
                                                width: media.width * 0.03,
                                                decoration:  BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: blueColor),
                                              )
                                                  : Container(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: media.height*0.01,),
                                        i=="en"?Divider(color: sub_text_color,):SizedBox()

                                      ],
                                    ),
                                  ),
                                ),


                              ),
                            )
                                .values
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: media.height*0.03,),
                    (choosenLanguage != '')
                        ? Button(
                      height: media.height*0.07,
                      width: media.width*0.85,
                      color: blueColor,
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await getlangid();
                          //saving language settings in local
                          pref.setString('languageDirection', languageDirection);
                          pref.setString('choosenLanguage', choosenLanguage);
                          setState(() {
                             _isLoading = false;
                          });
                           navigate();
                        },
                        text: languages[choosenLanguage]['text_confirm'])
                        : Container(),
                  ],),
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
                          padding: EdgeInsets.only(top: media.height * 0.04),
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
                        width: media.width * 0.08,
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: media.height * 0.05,
                              right: media.width * 0.02),
                          child: Text(
                            languages[choosenLanguage]['text_choose_language'],
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
                  top: media.height * 0.22,
                  left: 0,
                  right: 0,
                  child: Image.asset('assets/images/globe.png')),

              //loader
              (_isLoading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

class MyContainer extends StatefulWidget {
  const MyContainer({Key? key}) : super(key: key);

  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      height: media.height * 1,
      width: media.width * 1,
      color: blueColor,
      child: Column(
        children: [
          Container(
            height: media.width * 0.11 + MediaQuery.of(context).padding.top,
            width: media.width * 1,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            color: blueColor,
            child: Stack(
              children: [
                Container(
                  height: media.width * 0.11,
                  width: media.width * 1,
                  alignment: Alignment.center,
                  child: Text(
                    (choosenLanguage.isEmpty)
                        ? 'Choose Language'
                        : languages[choosenLanguage]['text_choose_language'],
                    style: GoogleFonts.roboto(
                        color: textColor,
                        fontSize: media.width * sixteen,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: media.width * 0.05,
          ),
          SizedBox(
            width: media.width * 0.9,
            height: media.height * 0.16,
            child: Image.asset(
              'assets/images/selectLanguage.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: media.width * 0.1,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: languages
                    .map(
                      (i, value) => MapEntry(
                        i,
                        InkWell(
                          onTap: () {
                            setState(() {
                              choosenLanguage = i;
                              if (choosenLanguage == 'ar' ||
                                  choosenLanguage == 'ur' ||
                                  choosenLanguage == 'iw') {
                                languageDirection = 'rtl';
                              } else {
                                languageDirection = 'ltr';
                              }
                            });
                          },
                          child: Container(

                            padding: EdgeInsets.all(media.width * 0.025),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  languagesCode
                                      .firstWhere((e) => e['code'] == i)['name']
                                      .toString(),
                                  style: GoogleFonts.roboto(
                                      fontSize: media.width * sixteen,
                                      color: textColor),
                                ),
                                Container(
                                  height: media.width * 0.05,
                                  width: media.width * 0.05,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: const Color(0xff222222),
                                          width: 1.2)),
                                  alignment: Alignment.center,
                                  child: (choosenLanguage == i)
                                      ? Container(
                                          height: media.width * 0.03,
                                          width: media.width * 0.03,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xff222222)),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          (choosenLanguage != '')
              ? Button(
                  onTap: () async {
                    setState(() {
                      //_isLoading = true;
                    });
                    await getlangid();
                    //saving language settings in local
                    pref.setString('languageDirection', languageDirection);
                    pref.setString('choosenLanguage', choosenLanguage);
                    setState(() {
                      // _isLoading = false;
                    });
                    // navigate();
                  },
                  text: languages[choosenLanguage]['text_confirm'])
              : Container(),
        ],
      ),
    );
  }
}
