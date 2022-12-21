import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../loadingPage/loading.dart';
import 'PaymentSuccessPage.dart';

class KNETPage extends StatefulWidget {
  var url;
  // Orders myOrdersItem;
  // LoginModel loginModel;
  KNETPage(this.url);
  // KNETPage(this.url, this.myOrdersItem, this.loginModel);

  @override
  createState() => _WebViewContainerState(this.url);
  // createState() => _WebViewContainerState(this.url, this.myOrdersItem);
}
class _WebViewContainerState extends State<KNETPage> {
  var _url;
  // Orders myOrdersItem;
  final _key = UniqueKey();
  bool isLoading=true;
  late SharedPreferences sharedPreferences;
  _WebViewContainerState(this._url);
  // _WebViewContainerState(this._url, this.myOrdersItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text(
          'KNET ${languages[choosenLanguage]['text_payment']}',
          textAlign: TextAlign.center,
          style: TextStyle(color: black),
        ),
        backgroundColor: white,
        // leading: InkWell(
        //     onTap: () {
        //       Navigator.pop(context);
        //     },
        //     child: Icon(Icons.arrow_back_ios, color: black,)),
      ),
      body:  Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: this._url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (url) {
              print("page Url"+url);
              if (url.contains("myfatoorah-driver-wallet-payment-success")) {
                // if(getOrderId(url)!=null){
                //   orderId = getOrderId(url);
                // }
                deleteSharedPrf();
                goToPaymentStatusPage(context, "wallet-payment-success");
                // goToPaymentStatusPage(context, true, myOrdersItem, true, true);
              } else if (url.contains("myfatoorah-driver-wallet-payment-error")) {
                goToPaymentStatusPage(context, "wallet-payment-error",);
                // goToPaymentStatusPage(context, false, myOrdersItem, false, false);
              } else if (url.contains("myfatoorah-ride-payment-success")) {
                goToPaymentStatusPage(context, "ride-payment-success",);
                // goToPaymentStatusPage(context, false, myOrdersItem, false, false);
              } else if (url.contains("myfatoorah-ride-payment-error")) {
                goToPaymentStatusPage(context, "ride-payment-error",);
                // goToPaymentStatusPage(context, false, myOrdersItem, false, false);
              }
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center( child: Loading())
              : Stack(),
        ],
      ),
    );
  }
  void deleteSharedPrf() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("cartList");
    sharedPreferences.remove('promo_code_data');
  }

  void goToPaymentStatusPage(BuildContext context,  paymentStatus) {
  // void goToPaymentStatusPage(BuildContext context, bool paymentStatus, Orders myOrdersItem, bool myOrderPage, bool myOrderPageKnet) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => PaymentSuccessPage(paymentStatus),
      ),
          (route) => false,//if you want to disable back feature set to false
    );
  }

}