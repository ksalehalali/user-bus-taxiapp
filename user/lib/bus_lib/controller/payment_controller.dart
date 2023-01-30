import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../Data/current_data.dart';
import '../model/charge_toSave_model.dart';
import '../model/payment_saved_model.dart';
import '../model/transaction_model.dart';
import '../view/screens/home/main_screen.dart';
import '../view/screens/map/map.dart';
import '../view/widgets/dialogs.dart';



class PaymentController extends GetxController {
  var paymentDone = false.obs;
  var directPaymentDone = false.obs;
  var paymentFailed = false.obs;
  var directPaymentFailed = false.obs;
  var totalOfMyPayments = 0.obs;
  var myBalance = '0.0'.obs;
  var recharges = <ChargeSaved>[].obs;
  var payments = <PaymentSaved>[].obs;
  var gotMyBalance = false.obs;
  var gotPayments = false.obs;
  var gotRecharges = false.obs;
  var openCam =false.obs;
  var allTrans = <TransactionModel>[].obs;
  int indexA = 0;
  int indexB = 0;
  var allTransSorted = <TransactionModel>[].obs;
  var ticketPayed= false.obs;


  Future<String> getPaymentCode()async{
    var data;
    var headers = {
      'Authorization': 'bearer ${user.accessToken}'
    };
    var request = http.Request('GET', Uri.parse('https://route.click68.com/api/divice/PaymentCode'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      data = json['description'];
      user.PaymentCode = data['paymentCode'].toString();
      print('payment code ====== $data');

    } else {
      print('payment code ====== ERROR');

      print(response.reasonPhrase);
    }
    return data['description'];
    //..........
  }

  Future getEncryptedCode(int paymentKind)async{
    var data;
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/QRCode'));
    request.body = json.encode({
      "Longitude": 11,
      "Latitude": 12,
      "PaymentKind":paymentKind
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      data = json['description'];

      print('Encrypted code ====== $data');

    } else {
      print('payment code ====== ERROR');

      print(response.reasonPhrase);
    }
    return data;
  }


  Future pay(bool isDirect) async {
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/PaymentMyWallet'));
    if(isDirect ==false){
      request.body = json.encode({
        "api_key": "\$FhlF]3;.OIic&{>H;_DeW}|:wQ,A8",
        "api_secret": "Z~P7-_/i!=}?BIwAd*S67LBzUo4O^G",
        "Value":   paymentSaved.value,
        "TripID": tripToSave.id,
        "BusId": paymentSaved.busId
      });
    }else{
      request.body = json.encode({
        "api_key": "\$FhlF]3;.OIic&{>H;_DeW}|:wQ,A8",
        "api_secret": "Z~P7-_/i!=}?BIwAd*S67LBzUo4O^G",
        "Value":   paymentSaved.value,
        "BusId": paymentSaved.busId
      });
    }

    if(ticketPayed.value ==false){
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var jsonResponse = jsonDecode(await response.stream.bytesToString());
      print(jsonResponse);

      if (jsonResponse['status']== true) {
        if(isDirect==true){
          directPaymentDone.value = true;
          directPaymentFailed.value =false;
        }{
          paymentFailed.value =false;
          paymentDone.value = true;
        }

        user.totalBalance = double.parse(jsonResponse['description']['total']);
        paymentSaved.id = jsonResponse['description']['paymentId'];
        paymentSaved.routeName = jsonResponse['description']['routeName'];
        paymentSaved.userName = jsonResponse['description']['userName'];
        print('value payed :: ${jsonResponse}');
        ticketPayed.value =true;
        if(isDirect ==false) panelController.open();
        openCam.value =false;

        Get.dialog(CustomDialog(
          fromPaymentLists: false,
          failedPay: false,
          payment: PaymentSaved(
              id:  paymentSaved.id,
              routeName: paymentSaved.routeName,
              userName: paymentSaved.userName,
              date: DateTime.now().toString(),
              createdDate: DateTime.now().toString(),
              value: paymentSaved.value),
        ));

        update();
        return true;
      }
      else {
        openCam.value =false;
        Get.dialog(CustomDialog(fromPaymentLists: false, failedPay: true));
        var json = jsonDecode(await response.stream.bytesToString());
        print(json);
        if(isDirect==true){
          directPaymentDone.value = false;
          directPaymentFailed.value =true;
          openCam.value =false;

        }{
          paymentDone.value = false;
          paymentFailed.value =true;
          openCam.value =false;

        }
        update();
        return false;
      }
    }

  }


  //pay with options
  Future payWithOptions(bool isDirect) async {
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/PaymentMyWallet'));
    if(isDirect ==false){
      request.body = json.encode({
        "api_key": "\$FhlF]3;.OIic&{>H;_DeW}|:wQ,A8",
        "api_secret": "Z~P7-_/i!=}?BIwAd*S67LBzUo4O^G",
        "Value":   paymentSaved.value,
        "TripID": tripToSave.id,
        "BusId": paymentSaved.busId
      });
    }else{
      request.body = json.encode({
        "api_key": "\$FhlF]3;.OIic&{>H;_DeW}|:wQ,A8",
        "api_secret": "Z~P7-_/i!=}?BIwAd*S67LBzUo4O^G",
        "Value":   paymentSaved.value,
        "BusId": paymentSaved.busId
      });
    }

    if(ticketPayed.value ==false){
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var jsonResponse = jsonDecode(await response.stream.bytesToString());
      print(jsonResponse);

      if (jsonResponse['status']== true) {
        if(isDirect==true){
          directPaymentDone.value = true;
          directPaymentFailed.value =false;
        }{
          paymentFailed.value =false;
          paymentDone.value = true;
        }

        user.totalBalance = double.parse(jsonResponse['description']['total']);
        paymentSaved.id = jsonResponse['description']['paymentId'];
        paymentSaved.routeName = jsonResponse['description']['routeName'];
        paymentSaved.userName = jsonResponse['description']['userName'];
        print('value payed :: ${jsonResponse}');
        ticketPayed.value =true;
        if(isDirect ==false) panelController.open();
        openCam.value =false;

        Get.dialog(CustomDialog(
          fromPaymentLists: false,
          failedPay: false,
          payment: PaymentSaved(
              id:  paymentSaved.id,
              routeName: paymentSaved.routeName,
              userName: paymentSaved.userName,
              date: DateTime.now().toString(),
              createdDate: DateTime.now().toString(),
              value: paymentSaved.value),
        ));
        update();
        return true;
      }
      else {
        openCam.value =false;
        Get.dialog(CustomDialog(fromPaymentLists: false, failedPay: true));
        var json = jsonDecode(await response.stream.bytesToString());
        print(json);
        if(isDirect==true){
          directPaymentDone.value = false;
          directPaymentFailed.value =true;
          openCam.value =false;

        }{
          paymentDone.value = false;
          paymentFailed.value =true;
          openCam.value =false;

        }
        update();
        return false;
      }
    }

  }

  Future<bool> recharge({required double invoiceValue,required String invoiceId,required String paymentGateway}) async {
    print('---------- == invoiceValue ::$invoiceValue ,,invoiceId :: $invoiceId ,, paymentGateway :: $paymentGateway ');
    var headers = {
      'Authorization':
          'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://route.click68.com/api/ChargeMyWallet'));
    request.body = json.encode({
      "api_key": "\$FhlF]3;.OIic&{>H;_DeW}|:wQ,A8",
      "api_secret": "Z~P7-_/i!=}?BIwAd*S67LBzUo4O^G",
      "invoiceValue": invoiceValue,
      "invoiceId":invoiceId ,
      "paymentGateway": paymentGateway
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var jsonResponse = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200 && jsonResponse['status'] ==true) {
      // Get.offAll(MainScreen(indexOfScreen: 2,));

      Get.snackbar("Success", "Recharge done",colorText: Colors.green);
      getMyWallet();
      getMyListOfRecharges();
      gotRecharges.value =true;
      gotPayments.value =true;
      update();
      return true;

    } else {
      print('recharge field =--------..........');
      Get.snackbar("Failed", "SomeThing wont wrong!!");

      print(response.reasonPhrase);
      print(jsonResponse);
      gotRecharges.value =true;
      gotPayments.value =true;
      update();
      return false;

    }

  }

  //send amount  user - user
  Future send({required String userName, required double value}) async {
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/ChargeWalletByUser'));

      request.body = json.encode({
        "api_key": "\$FhlF]3;.OIic&{>H;_DeW}|:wQ,A8",
        "api_secret": "Z~P7-_/i!=}?BIwAd*S67LBzUo4O^G",
        "ReciveUserName":userName,
        "Value":  value ,
      });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var jsonResponse = jsonDecode(await response.stream.bytesToString());
    print(jsonResponse);

    if (jsonResponse['status']== true) {
      print('value send :: ${jsonResponse}');

      update();
      return jsonResponse;
    }
    else {
      var json = jsonDecode(await response.stream.bytesToString());
      print(json);


      update();
      return jsonResponse;
    }
  }

  //get my wallet
  Future getMyWallet() async {
    myBalance.value ="0.000";
    var headers = {
      'Authorization':
          'bearer ${user.accessToken}'
    };
    var url =  Uri.parse('https://route.click68.com/api/GetWallet');
    var res = await  http.get(url,headers: headers);
    print(res.body);
    var jsonResponse = jsonDecode(res.body);
    if (res.statusCode == 200) {
      gotMyBalance.value = true;
      myBalance.value = jsonResponse['description']['total'];
      print(res.body);
      gotRecharges.value =true;
      gotPayments.value =true;
    } else {
      print(res.reasonPhrase);
    }
    update();
    return res.body;
  }

  //get list of recharges
  Future getMyListOfRecharges() async {
    gotRecharges.value =false;

    recharges.clear() ;
    allTrans.clear();

    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/ListChrgingWalletByUser'));
    request.body = json.encode({
      "PageNumber": 0,
      "PageSize": 100
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      var data = json['description'];
        for(int i =0; i < data.length; i++){
          recharges.add(
              ChargeSaved(
               id: data[i]['id'],
                userName: data[i]['userName'],
                invoiceValue: double.parse(data[i]['value']),
                createdDate: data[i]['date'],
                paymentGateway: data[i]['paymentGateway'],
                invoiceId: data[i]['invoiceId'].toString()
              )
          );

          allTrans.add(TransactionModel(
            time: data[i]['date'],
            amount: double.parse(data[i]['value']),
              type: data[i]['paymentGateway'],
            isPay: false
          ));
        }
        gotRecharges.value =true;
        update();
    }
    else {
      print(response.reasonPhrase);
    }
    // if(gotPayments.value ==true && gotRecharges.value==true){
    //   sort();
    // }
  }

  //get list of payments
  Future getMyListOfPayments() async {
    gotPayments.value =false;

    payments.clear() ;
    allTrans.clear();
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/ListPaymentWalletByUser'));
    request.body = json.encode({
      "PageNumber": 1,
      "PageSize": 500
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      var data = json['description'];
      totalOfMyPayments.value = json['total'];
print('payment ::${data[0]}');
      for(int i =0; i < data.length; i++){
        payments.add(
                PaymentSaved (
                  userName: data[i]['userName'],
                  createdDate: data[i]['date'],
                  value: double.parse(data[i]['value']),
                  id: data[i]['id'],
                  routeName: data[i]['routeName']??'',
                  date: data[i]['date'],
                  userBalance: data[i]['total']
            )
        );
        allTrans.add(TransactionModel(
          time: data[i]['date'],
          amount: double.parse(data[i]['value']),
          type: 'pay',
          isPay: true

        ));
      }
      gotPayments.value =true;
      update();

    }
    else {
      print(response.reasonPhrase);
    }
    // if(gotPayments.value ==true && gotRecharges.value==true){
    //   sort();
    // }
  }
  sort(){
    // var a = walletController.allTrans.where((p0) => p0.amount! ==0.105).toList();
    TransactionModel c =TransactionModel();
    c = allTrans[0];
    // print(DateTime.parse(walletController.allTrans[0].time!).hour);
   for(int i =0; i<allTrans.length;i++){
     for(int index =i; index< allTrans.length; index++){

         if(DateTime.parse(allTrans[i].time!).isBefore(DateTime.parse(c.time!))){
          c = allTrans[i];

         };


     }
     allTransSorted.add(c);

   }
    print(allTransSorted.length);
    for(int i =0; i<allTransSorted.length;i++){
    print("$i :: ${allTransSorted[i].time}");
  }

  }
}
