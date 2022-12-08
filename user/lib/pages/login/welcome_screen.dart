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
    return Scaffold(
      backgroundColor: white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/animated_images/welcome.png'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome', style: TextStyle(color: black, fontSize: 24.0, fontWeight: FontWeight.w600),),
              SizedBox(height: 20,),
              Text('Please Login to enter the exciting',
                style: TextStyle(color: light_grey, fontSize: 16.0),),
              SizedBox(height: 5,),
              Text('world of ride and deliveries',
                style: TextStyle(color: light_grey, fontSize: 16.0),),
            ],
          ),
          Container(
            height: 55,
            width: MediaQuery.of(context).size.width/2.5,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: notUploadedColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.0)
                    )
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EnterPhoneNumber()));
                },
                child: Text(languages[choosenLanguage]['text_login'], style: TextStyle(fontSize: 18.0),)
            ),
          ),
        ],
      ),
    );
  }
}