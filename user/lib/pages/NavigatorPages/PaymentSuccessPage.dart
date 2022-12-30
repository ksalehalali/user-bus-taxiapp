import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/walletpage.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../navDrawer/nav_drawer.dart';
import '../onTripPage/invoice.dart';
import '../onTripPage/map_page.dart';

class PaymentSuccessPage extends StatefulWidget {
  final paymentStatus;
  // bool myOrderPageKnet;
  PaymentSuccessPage(this.paymentStatus);

  @override
  createState() => PaymentSuccessState(this.paymentStatus);
}

class PaymentSuccessState extends State<PaymentSuccessPage> {
  final paymentStatus;
  bool isLoading = true;

  // bool  myOrderPageKnet;
  PaymentSuccessState(this.paymentStatus,);

  @override
  Widget build(BuildContext context) {

    bool buttonLoading = false;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => NavDrawer(),
                  ),
                      (route) => false,//if you want to disable back feature set to false
                );
              },
              child: Icon(
                Icons.clear,
                color: black,
                size: 20,
              )),
          title: new Text(
            languages[choosenLanguage]['text_payment_status'],
            textAlign: TextAlign.center,
            style: TextStyle(color: black),
          ),
          backgroundColor: white,
        ),
        backgroundColor: white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: paymentStatus == "wallet-payment-success" || paymentStatus == "ride-payment-success"
                    ? loaderColor : verifyDeclined,
                radius: 30,
                child: Icon(
                  paymentStatus == "wallet-payment-success" || paymentStatus == "ride-payment-success"
                      ?  Icons.check: Icons.clear,
                  color: white,
                  size: 50,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Text(
                  paymentStatus == "wallet-payment-success" || paymentStatus == "ride-payment-success"
                      ? "${languages[choosenLanguage]['text_congratulation']}!" : "${languages[choosenLanguage]['text_payment_error']}",
                  textAlign: TextAlign.center ,style: TextStyle(color: black, fontSize: 18),
                ),
              ),

              Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width/1.5,
                  margin:
                  EdgeInsets.fromLTRB(10, 15.0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: loaderColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        buttonLoading = true;
                      });
                      await getUserDetails();
                      setState(() {
                        buttonLoading = false;
                      });
                      Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => paymentStatus == "wallet-payment-success" || paymentStatus == "wallet-payment-error"
                              ? WalletPage() : paymentStatus == "ride-payment-success" ? Invoice(payment: "paid",) : paymentStatus == "ride-payment-error"
                              ? Invoice() : SizedBox(),
                        ),
                            (route) => false,//if you want to disable back feature set to false
                      );
                    },
                    child: buttonLoading ? FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset("assets/images/button_loading.gif"),
                    ) : Text(
                      paymentStatus == "wallet-payment-success" || paymentStatus == "wallet-payment-error"
                          ? languages[choosenLanguage]['text_go_to_wallet']
                          : languages[choosenLanguage]["text_go_to_invoice"],
                      style: TextStyle(color: white),),
                  )),

              // paymentStatus?Container(
              //     height: 40,
              //     width: MediaQuery.of(context).size.width/1.5,
              //     margin:
              //     EdgeInsets.fromLTRB(10, 15.0, 10, 0),
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         primary: loaderColor,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //       ),
              //       onPressed: () {
              //         Navigator.pushAndRemoveUntil<dynamic>(
              //           context,
              //           MaterialPageRoute<dynamic>(
              //             builder: (BuildContext context) => OrderSummaryPage('','','',myOrdersItem, myOrderPage, myOrderPageKnet, widget.loginModel),
              //           ),
              //               (route) => false,//if you want to disable back feature set to false
              //         );
              //       },
              //       child: Text(helpers.langsMap['go_to_order'],style: TextStyle(color: black),),
              //     )):SizedBox(),

            ],
          ),
        ));
  }

}
