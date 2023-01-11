import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/flutterwavepage.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/selectwallet.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/paystackpayment.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/razorpaypage.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/cashfreepage.dart';

import '../onTripPage/map_page.dart';
import 'KNETPage.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

dynamic addMoney;

class _WalletPageState extends State<WalletPage> {
  TextEditingController addMoneyController = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController amount = TextEditingController();
  String? payment_gateway = '';
  var current_payment_method_id;
  var tappedIndex;

  bool _isLoading = true;
  bool _addPayment = false;
  bool _choosePayment = false;
  bool _completed = false;
  bool showtoast = false;

  @override
  void initState() {
    getWallet();
    super.initState();
  }

//get wallet details
  getWallet() async {
    var val = await getWalletHistory();
    await getCountryCode();

    if (val == 'success') {
      _isLoading = false;
      _completed = true;
      valueNotifierBook.incrementNotifier();
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(value: "user", child: Text("User")),
      DropdownMenuItem(value: "driver", child: Text("Driver")),
      DropdownMenuItem(value: "owner", child: Text("Owner")),
    ];
    return menuItems;
  }

  showToast() {
    setState(() {
      showtoast = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showtoast = false;
      });
    });
  }

  String dropdownValue = 'user';
  bool error = false;
  bool amountError = false;
  String errortext = '';
  bool ispop = false;

  //show toast for copy

  navigate() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: ValueListenableBuilder(
          valueListenable: valueNotifierBook.value,
          builder: (context, value, child) {
            return Directionality(
              textDirection: (languageDirection == 'rtl')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(media.width * 0.05,
                          media.width * 0.05, media.width * 0.05, 0),
                      height: media.height * 1,
                      width: media.width * 1,
                      color: page,
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).padding.top),
                          Stack(
                            children: [
                              Container(
                                height: media.height * 0.1,
                                color: primaryColor,
                                width: media.width * 1,
                                alignment: Alignment.center,
                                child: Text(
                                  languages[choosenLanguage]
                                      ['text_enable_wallet'],
                                  style: GoogleFonts.roboto(
                                      fontSize: media.width * twentysix,
                                      fontWeight: FontWeight.w600,
                                      color: white),
                                ),
                              ),
                              Positioned(
                                top: media.height * 0.03,
                                left: media.width * 0.03,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Maps()));
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: white,
                                    size: media.height * 0.04,
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Image.asset(
                                    height: media.height * 0.1,
                                    'assets/images/app_bar_left_arrow.png',
                                    fit: BoxFit.cover,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          (walletBalance.isNotEmpty)
                              ? Padding(
                                padding: EdgeInsets.all(media.width * 0.05),
                                child: Container(
                                  // padding: EdgeInsets.fromLTRB(media.width * 0.05,
                                  //     media.width * 0.05, media.width * 0.05, 0),
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.zero,
                                    height: media.height * 0.2,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                    width: media.width,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/left_arrow.png',
                                          height: double.infinity,
                                          fit: BoxFit.fitHeight,
                                          width: media.width * 0.25,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: media.height * 0.065,
                                            ),
                                            Text(
                                              languages[choosenLanguage][
                                              'text_availablebalance'],
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width * sixteen,
                                                  color: white),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.01,
                                            ),
                                            SizedBox(
                                              width: media.width * 0.37,
                                              child: Center(
                                                child: Text(
                                                  walletBalance['currency_symbol'] + walletBalance['wallet_balance'].toString(),
                                                  style:
                                                  GoogleFonts.roboto(
                                                      fontSize: media.width * twenty,
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      color: white),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.05,
                                            ),
                                            // Button(
                                            //   onTap: () {
                                            //     setState(() {
                                            //       ispop = true;
                                            //     });
                                            //   },
                                            //   text: languages[choosenLanguage]
                                            //       ['text_share_money'],
                                            //   width: media.width * 0.3,
                                            // ),
                                            SizedBox(
                                              height: media.width * 0.05,
                                            ),
                                          ],
                                        ),
                                        Image.asset(
                                          'assets/images/right_arrow.png',
                                          height: double.infinity,
                                          fit: BoxFit.fitHeight,
                                          width: media.width * 0.28,
                                        ),
                                      ],
                                    )),
                              )
                              : Container(),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          SizedBox(
                            width: media.width * 0.9,
                            child: Text(
                              languages[choosenLanguage]
                              ['text_recenttransactions'],
                              style: GoogleFonts.roboto(
                                  fontSize: media.width * eighteen,
                                  color: textColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                              child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                (walletHistory.isNotEmpty)
                                    ? Column(
                                  children: walletHistory.asMap().map((i, value) {
                                    return MapEntry(i,
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: media.width * 0.02,
                                              bottom:
                                              media.width * 0.02),
                                          width: media.width * 0.9,
                                          padding: EdgeInsets.all(
                                              media.width * 0.025),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: borderLines,
                                                  width: 1.2),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(12),
                                              color: page),
                                          child: Row(
                                            children: [
                                              Container(
                                                  height:
                                                  media.width * 0.1067,
                                                  width: media.width * 0.1067,
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                  ),
                                                  alignment: Alignment
                                                      .center,
                                                  child: (walletHistory[
                                                  i][
                                                  'is_credit'] ==
                                                      1)
                                                      ? Image.asset('assets/images/arrow_green_down.png', width: 40 ,fit: BoxFit.cover,)
                                                      : Image.asset(
                                                      'assets/images/arrow_red_up.png', fit: BoxFit.cover, width: 40,)),
                                              // Text(
                                              //   (walletHistory[i][
                                              //   'is_credit'] ==
                                              //       1)
                                              //       ? '+'
                                              //       : '-',
                                              //   style: GoogleFonts.roboto(
                                              //       fontSize: media
                                              //           .width *
                                              //           twentyfour,
                                              //       color:
                                              //       textColor),
                                              // ),
                                              SizedBox(
                                                width: media.width *
                                                    0.025,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                    media.width * 0.58,
                                                    child: Text(
                                                      walletHistory[i]
                                                      [
                                                      'remarks']
                                                          .toString(),
                                                      style: GoogleFonts.roboto(
                                                          fontSize: media
                                                              .width *
                                                              sixteen,
                                                          color:
                                                          textColor,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                    media.width *
                                                        0.01,
                                                  ),
                                                  Text(
                                                    walletHistory[i][
                                                    'created_at']
                                                        .toString(),
                                                    style: GoogleFonts
                                                        .roboto(
                                                      fontSize: media
                                                          .width *
                                                          fourteen,
                                                      color:
                                                      light_grey,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 15,),
                                              Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    children: [
                                                      Expanded(
                                                        // alignment: Alignment
                                                        //     .centerRight,
                                                        // width:
                                                        // media.width *
                                                        //     0.20,
                                                        child: Text(
                                                          walletHistory[i]['currency_symbol'] + ' ' + walletHistory[i]['amount'].toString(),
                                                          style: GoogleFonts.roboto(
                                                              fontSize: media
                                                                  .width *
                                                                  fifteen,
                                                              color: (walletHistory[i]['is_credit'] !=
                                                                  1
                                                                  ? const Color(
                                                                  0xffE60000)
                                                                  : Color(
                                                                  0xFF2BCD62))),
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ));
                                  })
                                      .values
                                      .toList(),
                                )
                                    : (_completed == true)
                                        ? Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Container(
                                      height: media.width * 0.7,
                                      width: media.width * 0.7,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/nodatafound.gif'),
                                              fit: BoxFit.contain)),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.02,
                                    ),
                                    SizedBox(
                                      width: media.width * 0.9,
                                      child: Text(
                                        languages[choosenLanguage]
                                        ['text_noDataFound'],
                                        style: GoogleFonts.roboto(
                                            fontSize:
                                            media.width * sixteen,
                                            fontWeight:
                                            FontWeight.bold,
                                            color: textColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                )
                                        : Container(),

                                //load more button
                                (walletPages.isNotEmpty)
                                    ? (walletPages['current_page'] <
                                            walletPages['total_pages'])
                                        ? InkWell(
                                  onTap: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await getWalletHistoryPage(
                                        (walletPages['current_page'] + 1).toString());
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        media.width * 0.025),
                                    margin: EdgeInsets.only(
                                        bottom: media.width * 0.05),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: page,
                                        border: Border.all(
                                            color: borderLines,
                                            width: 1.2)),
                                    child: Text(
                                      languages[choosenLanguage]
                                      ['text_loadmore'],
                                      style: GoogleFonts.roboto(
                                          fontSize:
                                          media.width * sixteen,
                                          color: textColor),
                                    ),
                                  ),
                                )
                                        : Container()
                                    : Container()
                              ],
                            ),
                          )),

                          //add payment popup
                          (_addPayment == false)
                              ? Container(
                                  padding: EdgeInsets.only(
                                      top: media.width * 0.05,
                                      bottom: media.width * 0.05),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Button(
                                      //   onTap: () {
                                      //     Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 const Withdraw()));
                                      //   },
                                      //   text: languages[choosenLanguage]
                                      //       ['text_withdraw'],
                                      //   width: media.width * 0.4,
                                      // ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // Button(
                                          //   onTap: () {
                                          //     if (_addPayment == false) {
                                          //       setState(() {
                                          //         _addPayment = true;
                                          //       });
                                          //     }
                                          //   },
                                          //   text: languages[choosenLanguage]
                                          //   ['text_with_draw'],
                                          //   width: media.width * 0.4,
                                          // ),
                                          // SizedBox(width: 20,),

                                          InkWell(
                                            onTap: () {
                                              if (_addPayment == false) {
                                                setState(() {
                                                  _addPayment = true;
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: media.width/1.2,
                                              height: media.width * 0.14,
                                              // width: (widget.width != null) ? widget.width : null,
                                              padding: EdgeInsets.only(left: media.width * twenty, right: media.width * twenty),
                                              decoration: BoxDecoration(
                                                // border: Border.all(color: (resendTime != 0 && otpNumber.length != 6)
                                                //     ? hideButtonColor
                                                //     : buttonColor, width: 1.5),
                                                borderRadius: BorderRadius.circular(30),
                                                color: primaryColor,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text('${languages[choosenLanguage]['text_addmoney']}', style: TextStyle(color: white, fontSize: media.width * eighteen),),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),

                    //add payment
                    (_addPayment == true)
                        ? Positioned(
                            bottom: 0,
                            child: Container(
                              height: media.height * 1,
                              width: media.width * 1,
                              color: Colors.transparent.withOpacity(0.6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: media.height * 0.4,
                                    // margin: EdgeInsets.only(
                                    //     bottom: media.width * 0.05),
                                    // width: media.width * 0.9,
                                    // padding:
                                    //     EdgeInsets.all(media.width * 0.025),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: borderLines, width: 1.2),
                                        color: page),
                                    child: Column(children: [
                                      SizedBox(
                                        height: media.height * 0.03,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
                                        // padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: media.width * 0.128,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: borderLines, width: 1.2),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                  width: media.width * 0.2,
                                                  height: media.width * 0.128,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(12),
                                                        bottomLeft:
                                                            Radius.circular(12),
                                                      ),
                                                      color: light_grey.withOpacity(0.2))
                                                  ,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    walletBalance[
                                                        'currency_symbol'],
                                                    style: GoogleFonts.roboto(
                                                        fontSize:
                                                            media.width * fifteen,
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )),
                                              SizedBox(
                                                width: media.width * 0.05,
                                              ),
                                              Container(
                                                height: media.width * 0.128,
                                                // height: media.width * 0.128,
                                                width: media.width * 0.6,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  controller: addMoneyController,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      addMoney = int.parse(val);
                                                    });
                                                  },
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                        languages[choosenLanguage]
                                                            ['text_enteramount'],
                                                    hintStyle: GoogleFonts.roboto(
                                                        fontSize:
                                                            media.width * fifteen,
                                                        color: hintColor),
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 8,),
                                      amountError ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Please enter valid amount', style: TextStyle(color: Colors.red),)) : SizedBox(),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                addMoneyController.text = '100';
                                                addMoney = 100;
                                              });
                                            },
                                            child: Container(
                                              height: media.width * 0.11,
                                              width: media.width * 0.17,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: borderLines,
                                                      width: 1.2),
                                                  color: page,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              alignment: Alignment.center,
                                              child: Text(
                                                walletBalance[
                                                        'currency_symbol'] +
                                                    '100',
                                                style: GoogleFonts.roboto(
                                                    fontSize:
                                                        media.width * fourteen,
                                                    color: textColor.withOpacity(0.7),
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: media.width * 0.05,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                addMoneyController.text = '500';
                                                addMoney = 500;
                                              });
                                            },
                                            child: Container(
                                              height: media.width * 0.13,
                                              width: media.width * 0.23,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: borderLines,
                                                      width: 1.2),
                                                  color: page,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              alignment: Alignment.center,
                                              child: Text(
                                                walletBalance[
                                                        'currency_symbol'] +
                                                    '500',
                                                style: GoogleFonts.roboto(
                                                    fontSize:
                                                        media.width * fourteen,
                                                    color: textColor.withOpacity(0.7),
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: media.width * 0.05,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                addMoneyController.text =
                                                    '1000';
                                                addMoney = 1000;
                                              });
                                            },
                                            child: Container(
                                              height: media.width * 0.13,
                                              width: media.width * 0.23,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: borderLines,
                                                      width: 1.2),
                                                  color: page,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              alignment: Alignment.center,
                                              child: Text(
                                                walletBalance[
                                                        'currency_symbol'] +
                                                    '1000',
                                                style: GoogleFonts.roboto(
                                                    fontSize:
                                                        media.width * fourteen,
                                                    color: textColor.withOpacity(0.7),
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.width * 0.1,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              // print(addMoney);
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              if (addMoney != 0 && addMoney != null) {
                                                setState(() {
                                                  _choosePayment = true;
                                                  _addPayment = false;
                                                  amountError = false;
                                                });
                                              } else {
                                                setState(() {
                                                  amountError = true;
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: media.width * 0.4,
                                              height: media.width * 0.13,
                                              // width: (widget.width != null) ? widget.width : null,
                                              padding: EdgeInsets.only(left: media.width * twenty, right: media.width * twenty),
                                              decoration: BoxDecoration(
                                                // border: Border.all(color: (resendTime != 0 && otpNumber.length != 6)
                                                //     ? hideButtonColor
                                                //     : buttonColor, width: 1.5),
                                                borderRadius: BorderRadius.circular(30),
                                                color: primaryColor,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text('${languages[choosenLanguage]['text_addmoney']}', style: TextStyle(color: white, fontSize: media.width * eighteen),),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                _addPayment = false;
                                                addMoney = null;
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                addMoneyController.clear();
                                              });
                                            },
                                            child: Container(
                                              width: media.width * 0.4,
                                              height: media.width * 0.13,
                                              // width: (widget.width != null) ? widget.width : null,
                                              padding: EdgeInsets.only(left: media.width * twenty, right: media.width * twenty),
                                              decoration: BoxDecoration(
                                                // border: Border.all(color: (resendTime != 0 && otpNumber.length != 6)
                                                //     ? hideButtonColor
                                                //     : buttonColor, width: 1.5),
                                                borderRadius: BorderRadius.circular(30),
                                                color: primaryColor,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text('${languages[choosenLanguage]['text_cancel']}', style: TextStyle(color: white, fontSize: media.width * eighteen),),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                            ))
                        : Container(),

                    //choose payment method
                    (_choosePayment == true)
                        ? Positioned(
                            child: Container(
                            height: media.height * 1,
                            width: media.width * 1,
                            color: Colors.transparent.withOpacity(0.6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   width: media.width * 0.8,
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.end,
                                //     children: [
                                //       InkWell(
                                //         onTap: () {
                                //           setState(() {
                                //             _choosePayment = false;
                                //             _addPayment = true;
                                //             payment_gateway == "";
                                //           });
                                //         },
                                //         child: Container(
                                //           height: media.height * 0.05,
                                //           width: media.height * 0.05,
                                //           decoration: BoxDecoration(
                                //             color: page,
                                //             shape: BoxShape.circle,
                                //           ),
                                //           child: Icon(Icons.cancel,
                                //               color: buttonColor),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                SizedBox(height: media.width * 0.025),
                                SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.all(media.width * 0.05),
                                    width: media.width * 0.8,
                                    height: media.height * 0.6,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: page),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _choosePayment = false;
                                              _addPayment = true;
                                              payment_gateway == "";
                                            });
                                          },
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Icon(Icons.cancel,
                                                color: light_grey),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Text(
                                          languages[choosenLanguage]
                                              ['text_choose_payment'],
                                          style: GoogleFonts.roboto(
                                              fontSize:
                                                  media.width * twentyfour,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            physics: const BouncingScrollPhysics(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                (walletBalance['stripe'] == true)
                                                    ? Card(
                                                  elevation: 3.0,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                                  child: InkWell(
                                                  onTap: () {
                                                      setState(() {
                                                        payment_gateway = "stripe";
                                                      });
                                                  },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                              // height: 40, width: 50,
                                                              child: RadioListTile(
                                                                contentPadding: EdgeInsets.all(0),
                                                                value: "stripe",
                                                                groupValue: payment_gateway,
                                                                onChanged: (value){
                                                                  setState(() {
                                                                    payment_gateway = value.toString();
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: Container(
                                                                  width: media.width *
                                                                      0.16,
                                                                  height: media.width *
                                                                      0.16,
                                                                  decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(
                                                                              'assets/images/stripe-icon.png'),
                                                                          fit: BoxFit
                                                                              .contain)),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    : Container(),
                                                (walletBalance['paystack'] == true)
                                                    ? Card(
                                                  elevation: 3.0,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                                  child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            payment_gateway = "paystack";
                                                          });
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                              // height: 40, width: 50,
                                                              child: RadioListTile(
                                                                value: "paystack",
                                                                groupValue: payment_gateway,
                                                                onChanged: (value){
                                                                  setState(() {
                                                                    payment_gateway = value.toString();
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: Container(
                                                                  width: media.width *
                                                                      0.16,
                                                                  height: media.width *
                                                                      0.16,
                                                                  decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(
                                                                              'assets/images/paystack-icon.png'),
                                                                          fit: BoxFit
                                                                              .contain)),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    : Container(),
                                                (walletBalance['flutter_wave'] == true)
                                                    ? Card(
                                                  elevation: 3.0,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                                  child: InkWell(
                                                  onTap: () {
                                                      setState(() {
                                                        payment_gateway = "flutter_wave";
                                                      });
                                                  },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                              // height: 40, width: 50,
                                                              child: RadioListTile(
                                                                value: "flutter_wave",
                                                                groupValue: payment_gateway,
                                                                onChanged: (value){
                                                                  setState(() {
                                                                    payment_gateway = value.toString();
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: Container(
                                                                  width: media.width *
                                                                      0.16,
                                                                  height: media.width *
                                                                      0.16,
                                                                  decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(
                                                                              'assets/images/flutterwave-icon.png'),
                                                                          fit: BoxFit
                                                                              .contain)),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    : Container(),
                                                (walletBalance['razor_pay'] == true)
                                                    ? Card(
                                                  elevation: 3.0,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                                  child: InkWell(
                                                  onTap: () {
                                                      setState(() {
                                                        payment_gateway = "razor_pay";
                                                      });
                                                  },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                              // height: 40, width: 50,
                                                              child: RadioListTile(
                                                                value: "razor_pay",
                                                                groupValue: payment_gateway,
                                                                onChanged: (value){
                                                                  setState(() {
                                                                    payment_gateway = value.toString();
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: Container(
                                                                  width: media.width *
                                                                      0.16,
                                                                  height: media.width *
                                                                      0.16,
                                                                  decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(
                                                                              'assets/images/razorpay-icon.jpeg'),
                                                                          fit: BoxFit
                                                                              .contain)),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    : Container(),
                                                (walletBalance['cash_free'] == true)
                                                    ? Card(
                                                  elevation: 3.0,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                                  child: InkWell(
                                                  onTap: () {
                                                      setState(() {
                                                        payment_gateway = "cash_free";
                                                      });
                                                  },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                              // height: 40, width: 50,
                                                              child: RadioListTile(
                                                                value: "cash_free",
                                                                groupValue: payment_gateway,
                                                                onChanged: (value){
                                                                  setState(() {
                                                                    payment_gateway = value.toString();
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: Container(
                                                                  width: media.width * 0.16,
                                                                  height: media.width * 0.16,
                                                                  decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage('assets/images/cashfree-icon.jpeg'),
                                                                          fit: BoxFit.contain)),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    : Container(),
                                                (walletBalance['myfatoorah'])
                                                    ? Container(
                                                    // margin: EdgeInsets.only(bottom: media.width * 0.025),
                                                    // margin: EdgeInsets.zero,
                                                    // padding: EdgeInsets.zero,
                                                    // alignment: Alignment.center,
                                                    // width: media.width * 0.7,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: walletBalance['myfatoorah_payment_methods'].length,
                                                        itemBuilder: (context, index) {
                                                          return Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Card(
                                                                elevation: 3.0,
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      payment_gateway = walletBalance['myfatoorah_payment_methods'][index]['PaymentMethodEn'];
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    padding: EdgeInsets.all(3.0),
                                                                    decoration: BoxDecoration(
                                                                      color: payment_gateway == walletBalance['myfatoorah_payment_methods'][index]['PaymentMethodEn'] ? paymentMethodsColor : null,
                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      // crossAxisAlignment: CrossAxisAlignment.end,
                                                                      children: [
                                                                        Container(
                                                                          height: 50, width: 50,
                                                                          // flex: 1,
                                                                          child: RadioListTile(
                                                                            activeColor: loaderColor,
                                                                            contentPadding: EdgeInsets.all(0),
                                                                            value: "${walletBalance['myfatoorah_payment_methods'][index]['PaymentMethodEn']}",
                                                                            groupValue: payment_gateway,
                                                                            onChanged: (value){
                                                                              setState(() {
                                                                                payment_gateway = value.toString();
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                            height: media.width * 0.16,
                                                                            width: media.width * 0.16,
                                                                            // flex: 1,
                                                                            // width: 50, height: 30,
                                                                            child: Container(
                                                                                width: media.width * 0.5,
                                                                                height: media.width * 0.010,
                                                                                child: Image.network(walletBalance['myfatoorah_payment_methods'][index]['ImageUrl'], fit: BoxFit.contain))),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,)
                                                            ],
                                                          );
                                                        }
                                                    ))
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                        payment_gateway!.isEmpty || payment_gateway == null
                                            ? SizedBox()
                                            : InkWell(
                                          onTap: () async {
                                            if(payment_gateway == 'stripe') {
                                              var val = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          SelectWallet()));
                                              if (val) {
                                                setState(() {
                                                  _choosePayment =
                                                  false;
                                                  _addPayment =
                                                  false;
                                                  addMoney = null;
                                                  addMoneyController
                                                      .clear();
                                                });
                                              }
                                            }
                                            if(payment_gateway == 'paystack') {
                                              var val = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          PayStackPage()));
                                              if (val) {
                                                setState(() {
                                                  _choosePayment =
                                                  false;
                                                  _addPayment =
                                                  false;
                                                  addMoney = null;
                                                  addMoneyController
                                                      .clear();
                                                  _isLoading = true;
                                                });
                                                getWallet();
                                              }
                                            }
                                            if(payment_gateway == 'flutter_wave') {
                                              var val = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          FlutterWavePage()));
                                              if (val) {
                                                setState(() {
                                                  _choosePayment =
                                                  false;
                                                  _addPayment =
                                                  false;
                                                  addMoney = null;
                                                  addMoneyController
                                                      .clear();
                                                });
                                              }
                                            }
                                            if(payment_gateway == 'razor_pay') {
                                              var val = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          RazorPayPage()));
                                              if (val) {
                                                setState(() {
                                                  _choosePayment =
                                                  false;
                                                  _addPayment =
                                                  false;
                                                  addMoney = null;
                                                  addMoneyController
                                                      .clear();
                                                });
                                              }
                                            }
                                            if(payment_gateway == 'cash_free') {
                                              var val = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          CashFreePage()));
                                              if (val) {
                                                setState(() {
                                                  _choosePayment =
                                                  false;
                                                  _addPayment =
                                                  false;
                                                  addMoney = null;
                                                  addMoneyController
                                                      .clear();
                                                });
                                              }
                                            }
                                            if(payment_gateway == 'KNET' ) {
                                              getMyFatoorahLink(walletBalance['myfatoorah_payment_methods'][0]['PaymentMethodId'], addMoney).then((value) {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => KNETPage(value)));
                                              });
                                              // setState(() {
                                              //   payment_gateway!.isEmpty;
                                              // });
                                            }
                                            // if(payment_gateway == 'Apple Pay') {
                                            //   getMyFatoorahLink(walletBalance['myfatoorah_payment_methods'][11]['PaymentMethodId'], addMoney).then((value) {
                                            //     Navigator.push(context, MaterialPageRoute(builder: (context) => KNETPage(value)));
                                            //   });
                                            //   setState(() {
                                            //     payment_gateway!.isEmpty;
                                            //   });
                                            // }
                                            if(payment_gateway == 'VISA/MASTER') {
                                              getMyFatoorahLink(walletBalance['myfatoorah_payment_methods'][1]['PaymentMethodId'], addMoney).then((value) {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => KNETPage(value)));
                                              });
                                              // setState(() {
                                              //   payment_gateway!.isEmpty;
                                              // });
                                            }
                                          },
                                              child: Container(
                                                width: media.width,
                                          height: media.width * 0.13,
                                          padding: EdgeInsets.all(media.width * 0.025),
                                          margin: EdgeInsets.only(bottom: media.width * 0.05),
                                          decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(22),
                                                color: primaryColor,
                                                border: Border.all(color: borderLines, width: 1.2)),
                                          child: Center(
                                            child: Text('${languages[choosenLanguage]
                                            ['text_pay']}', style: GoogleFonts.roboto(
                                                fontSize:
                                                media.width * eighteen,
                                                color: white), textAlign: TextAlign.center,),
                                          )
                                        ),
                                            )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                        : Container(),
                    //no internet
                    (internet == false)
                        ? Positioned(
                            top: 0,
                            child: NoInternet(
                              onTap: () {
                                setState(() {
                                  internetTrue();
                                  // _complete = false;
                                  _isLoading = true;
                                  getWallet();
                                });
                              },
                            ))
                        : Container(),

                    (ispop == true)
                        ? Positioned(
                            top: 0,
                            child: Container(
                              height: media.height * 1,
                              width: media.width * 1,
                              color: Colors.transparent.withOpacity(0.6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      padding:
                                          EdgeInsets.all(media.width * 0.05),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: page),
                                      width: media.width * 0.8,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: page,
                                              ),
                                              dropdownColor: page,
                                              value: dropdownValue,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValue = newValue!;
                                                });
                                              },
                                              items: dropdownItems),
                                          InputField(
                                              text: languages[choosenLanguage]
                                                  ['text_enteramount'],
                                              textController: amount,
                                              inputType: TextInputType.number
                                          ),
                                          // InputField(
                                          //     text: languages[choosenLanguage]
                                          //         ['text_phone_number'],
                                          //     textController: phonenumber,
                                          //     inputType: TextInputType.number),
                                          TextFormField(
                                            controller: phonenumber,
                                            onChanged: (val) {
                                              if (phonenumber.text.length ==
                                                  countries[phcode.value]
                                                      ['dial_max_length']) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              }
                                            },
                                            // maxLength: countries[phcode]
                                            //     ['dial_max_length'],
                                            style: GoogleFonts.roboto(
                                                fontSize: media.width * sixteen,
                                                color: textColor,
                                                letterSpacing: 1),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText:
                                                  languages[choosenLanguage]
                                                      ['text_phone_number'],
                                              counterText: '',
                                              hintStyle: GoogleFonts.roboto(
                                                  fontSize:
                                                      media.width * sixteen,
                                                  color: textColor
                                                      .withOpacity(0.7)),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: inputfocusedUnderline,
                                                width: 1.2,
                                                style: BorderStyle.solid,
                                              )),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: inputUnderline,
                                                width: 1.2,
                                                style: BorderStyle.solid,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.05,
                                          ),
                                          error == true
                                              ? Text(
                                                  errortext,
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: media.width * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Button(
                                                  width: media.width * 0.2,
                                                  height: media.width * 0.09,
                                                  onTap: () {
                                                    setState(() {
                                                      ispop = false;
                                                      dropdownValue = 'user';
                                                      error = false;
                                                      errortext = '';
                                                      phonenumber.text = '';
                                                      amount.text = '';
                                                    });
                                                  },
                                                  text:
                                                      languages[choosenLanguage]
                                                          ['text_close']),
                                              SizedBox(
                                                width: media.width * 0.05,
                                              ),
                                              Button(
                                                  width: media.width * 0.2,
                                                  height: media.width * 0.09,
                                                  onTap: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    if (phonenumber.text ==
                                                            '' ||
                                                        amount.text == '') {
                                                      setState(() {
                                                        error = true;
                                                        errortext = languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_fill_fileds'];
                                                        _isLoading = false;
                                                      });
                                                    } else {
                                                      var result =
                                                          await sharewalletfun(
                                                              amount:
                                                                  amount.text,
                                                              mobile:
                                                                  phonenumber
                                                                      .text,
                                                              role:
                                                                  dropdownValue);
                                                      if (result == 'success') {
                                                        // navigate();
                                                        setState(() {
                                                          ispop = false;
                                                          dropdownValue =
                                                              'user';
                                                          error = false;
                                                          errortext = '';
                                                          phonenumber.text = '';
                                                          amount.text = '';
                                                          getWallet();
                                                          showToast();
                                                        });
                                                      } else {
                                                        setState(() {
                                                          error = true;
                                                          errortext =
                                                              result.toString();
                                                          _isLoading = false;
                                                        });
                                                      }
                                                    }
                                                  },
                                                  text:
                                                      languages[choosenLanguage]
                                                          ['text_share']),
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          )
                        : Container(),

                    //loader
                    (_isLoading == true)
                        ? const Positioned(child: Loading())
                        : Container(),
                    (showtoast == true)
                        ? Positioned(
                            bottom: media.height * 0.2,
                            left: media.width * 0.2,
                            right: media.width * 0.2,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(media.width * 0.025),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent.withOpacity(0.6)),
                              child: Text(
                                languages[choosenLanguage]
                                    ['text_transferred_successfully'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: Colors.white),
                              ),
                            ))
                        : Container()
                  ],
                ),
              ),
            );
          }),
    );
  }
}
