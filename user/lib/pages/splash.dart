import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loadingpage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}


class _SplashState extends State<Splash> {

  navigate() async {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoadingPage()),
              (route) => false);
    });

  }


  @override
  void initState() {

   navigate();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox.expand(
          child: Image.asset(
            "assets/images/splash.gif",
            fit: BoxFit.cover,
          )
      ),);
  }
}
