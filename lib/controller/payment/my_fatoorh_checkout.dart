import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfatoorah_pay/myfatoorah_pay.dart';
import '../../Data/current_data.dart';
import '../../view/screens/home/Home.dart';
import '../../view/screens/home/main_screen.dart';
import '../lang_controller.dart';
import '../packages_controller.dart';
import '../payment_controller.dart';



class MyFatoorahCheckOut {
  final PaymentController walletController = Get.find();
  final LangController langController = Get.find();
  final PackagesController packagesController = Get.find();

  static const String myFatoorahApi = 'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL';
  Future initiate(BuildContext context, double amount, int paymentMethodId ,bool isPackage,String packageId) async {
    var response = await MyFatoorahPay.startPayment(

      context: context,
      errorChild: Home(),
      successChild: Home(),
      showServiceCharge: true,
      afterPaymentBehaviour: AfterPaymentBehaviour.BeforeCallbackExecution,
      request: MyfatoorahRequest.test(

        currencyIso: Country.Kuwait,
        invoiceAmount: amount,
        language:langController.appLocal =="ar"? ApiLanguage.Arabic :ApiLanguage.English,
        token: myFatoorahApi,


      ),
    );
    print(response.status);
    print(response.isSuccess);
    print(response.paymentId);
    print(response.url);
    if(!response.isSuccess){
    if(isPackage ==false){
      walletController.recharge(invoiceId:response.paymentId!,invoiceValue: amount,paymentGateway:'visa/mastercard',  );

      print("booody :: ${response}");
      chargeSaved.invoiceId = response.paymentId;
      chargeSaved.invoiceValue = amount;

      Get.offAll(MainScreen(indexOfScreen: 2,));
    }else{
      packagesController.addPackage(invoiceId: response.paymentId!,id:packageId,isCard: true );
    }
    }else{
      print('recharge field');
      print(response.status);
      Get.snackbar('Recharge Failed', 'Some thing wont wrong!',);

    }

  }

}
