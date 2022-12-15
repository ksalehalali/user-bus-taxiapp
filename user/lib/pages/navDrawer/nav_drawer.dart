import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/editprofile.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/favourite.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/history.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/makecomplaint.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/referral.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/walletpage.dart';
import 'package:tagyourtaxi_driver/pages/language/languages.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/pages/splash.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';

import '../NavigatorPages/notification.dart';
import 'drawer_model.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {

  List<DrawerModel> drawerList = [];

  @override
  void initState() {

    drawerList.add(DrawerModel( languages[choosenLanguage]['text_enable_history'].toString(), 'assets/images/history.png', History()));
    drawerList.add(DrawerModel( languages[choosenLanguage]['text_notification'].toString(), 'assets/images/notification.png', NotificationPage()));
    drawerList.add(DrawerModel( languages[choosenLanguage]['text_enable_wallet'].toString(), 'assets/images/walletIcon.png', WalletPage()));
    drawerList.add(DrawerModel( languages[choosenLanguage]['text_enable_referal'].toString(), 'assets/images/referral.png', ReferralPage()));
    drawerList.add(DrawerModel( languages[choosenLanguage]['text_favourites'].toString(), Icons.favorite_border, Favorite()));
    drawerList.add(DrawerModel( languages[choosenLanguage]['text_change_language'].toString(), 'assets/images/changeLanguage.png', Languages(true)));
    drawerList.add(DrawerModel( languages[choosenLanguage]['text_make_complaints'].toString(), 'assets/images/makecomplaint.png', MakeComplaint(fromPage: 0,)));
    drawerList.add(DrawerModel( languages[choosenLanguage]['text_delete_account'].toString(), Icons.delete_forever, Splash()));
    drawerList.add(DrawerModel( languages[choosenLanguage]['text_logout'].toString(), 'assets/images/logout.png', Splash()));


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: media.width * 0.8,
        margin: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: white,
        ),
        child: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Drawer(
              backgroundColor: white,
              shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: white,
                ),
                width: media.width * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: media.width * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: media.width * 0.2,
                                width: media.width * 0.2,
                                margin: EdgeInsets.only(top: 16, bottom: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(userDetails['profile_picture']),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                width: media.width * 0.025,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: media.width * 0.45,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: media.width * 0.3,
                                          child: Text(
                                            userDetails['name'],
                                            style: GoogleFonts.roboto(
                                                fontSize: media.width * eighteen,
                                                color: drawerTextColor,
                                                fontWeight: FontWeight.w600),
                                            maxLines: 1,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            var val = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    const EditProfile()));
                                            if (val) {
                                              setState(() {});
                                            }
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            size: media.width * eighteen,
                                            color: drawerTextColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: media.width * 0.01,
                                  ),
                                  SizedBox(
                                    width: media.width * 0.45,
                                    child: Text(
                                      userDetails['email'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * fourteen,
                                          color: drawerTextColor),
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        ListView.builder(
                            itemCount:drawerList.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return index == 1 ? ValueListenableBuilder(
                                  valueListenable: valueNotifierNotification.value,
                                  builder: (context, value, child) {
                                    return Padding(
                                      padding:  EdgeInsets.only(left: 8.0, right: 8, top: 10),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            drawerSelectedIndex = index;
                                          });

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                  const NotificationPage()));
                                          setState(() {
                                            userDetails['notifications_count'] = 0;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: drawerSelectedIndex == index ? loaderColor : white,
                                            // border: Border(
                                            //   left: BorderSide(width: 5.0, color: drawerSelectedIndex == index ? white : light_grey,),
                                            //
                                            // ),

                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(media.width * 0.035),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      drawerList[index].icon,
                                                      fit: BoxFit.contain,
                                                      width: media.width * 0.075,
                                                      color: drawerSelectedIndex != index ? drawerTextColor : white,
                                                    ),
                                                    SizedBox(
                                                      width: media.width * 0.025,
                                                    ),
                                                    SizedBox(
                                                      width: media.width * 0.49,
                                                      child: Text(
                                                        drawerList[index].name,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.roboto(
                                                            fontSize: media.width * sixteen,
                                                            color: drawerSelectedIndex != index ? drawerTextColor : white),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              (userDetails['notifications_count'] == 0)
                                                  ? Container()
                                                  : Container(
                                                height: 20,
                                                width: 20,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: drawerSelectedIndex != index ? drawerTextColor : white,
                                                ),
                                                child: Text(
                                                  userDetails['notifications_count']
                                                      .toString(),
                                                  style: GoogleFonts.roboto(
                                                      fontSize: media.width * fourteen,
                                                      color: drawerSelectedIndex != index ? drawerTextColor : white),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ) :  Padding(
                                padding:  EdgeInsets.only(left: 8.0, right: 8, top: 10),
                                child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      drawerSelectedIndex = index;
                                    });

                                    if(index == 1){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const NotificationPage()));
                                      setState(() {
                                        userDetails['notifications_count'] = 0;
                                      });
                                    }else if(index == drawerList.length - 2){
                                      setState(() {
                                        deleteAccount = true;
                                      });
                                      valueNotifierHome.incrementNotifier();
                                      Navigator.pop(context);
                                    }else if(index == drawerList.length - 1){
                                      setState(() {
                                        logout = true;
                                      });
                                      valueNotifierHome.incrementNotifier();
                                      Navigator.pop(context);
                                    }else {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => drawerList[index].pageName));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: drawerSelectedIndex == index ? loaderColor : white,
                                      // border: Border(
                                      //   left: BorderSide(width: 5.0, color: drawerSelectedIndex == index ? white : light_grey,),
                                      //
                                      // ),
                                      borderRadius: BorderRadius.circular(12.0),


                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(media.width * 0.025),
                                      child: Row(
                                        children: [
                                          drawerList[index].icon.runtimeType != IconData ? Image.asset(
                                            drawerList[index].icon,
                                            fit: BoxFit.contain,
                                            width: media.width * 0.075,
                                            color: drawerSelectedIndex != index ? drawerTextColor : white,
                                          ) : Icon( drawerList[index].icon,
                                            color: drawerSelectedIndex != index ? drawerTextColor : white,
                                          ),
                                          SizedBox(
                                            width: media.width * 0.025,
                                          ),
                                          SizedBox(
                                            width: media.width * 0.55,
                                            child: Text(
                                              drawerList[index].name,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width * sixteen,
                                                  color: drawerSelectedIndex != index ? drawerTextColor : white),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
                        Text(version)
                      ]),
                ),
              )),
        ),
      ),
    );
  }
}
