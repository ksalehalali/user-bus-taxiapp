import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:routes/view/screens/Auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Assistants/globals.dart';
import '../Data/current_data.dart';
import '../view/screens/home/main_screen.dart';

class SignUpController extends GetxController {

  final phoneNumController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();

  final codeController = new TextEditingController();
  var isSignUpLoading = false.obs;

  RxString phoneNum = "".obs;

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 120;
  late CountdownTimerController controller;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  @override
  void onClose() {
    super.onClose();
    phoneNumController.dispose();
    passwordController.dispose();
  }





  Future<bool> makeSignUpRequest(context) async {

    List<String> signUpCredentials = [
      phoneNum.value.replaceAll("+", ""),
      passwordController.text
    ];

    var head = {
      "Accept": "application/json",
      "content-type":"application/json"
    };

    print("sssss");
    print("${signUpCredentials[0]}");
    print("${signUpCredentials[1]}");

    if (signUpCredentials[0].isEmpty || signUpCredentials[1].isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill all the required information",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0);
      return false;
    } else if(signUpCredentials[0].length < 8){
      Fluttertoast.showToast(
          msg: "Please enter a valid phone number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0);
      return false;
    } else {
      var response = await http.post(Uri.parse(baseURL + "/api/Register"), body: jsonEncode(
        {
          "UserName": "${signUpCredentials[0]}",
          "Password": signUpCredentials[1]
        },
      ), headers: head
      ).timeout(const Duration(seconds: 20), onTimeout:(){
        Fluttertoast.showToast(
            msg: "The connection has timed out, Please try again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white70,
            textColor: Colors.black,
            fontSize: 16.0
        );
        throw TimeoutException('The connection has timed out, Please try again!');
      });

      print("eeeeeeeeeeehhhhh ${response.statusCode}");
      print("eeeeeeeeeeehhhhh ${response.body}");

      if(response.statusCode == 500) {
        Fluttertoast.showToast(
            msg: "Error 500",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white70,
            textColor: Colors.black,
            fontSize: 16.0);
        return false;
      } else if(response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if(jsonResponse["status"]){
          print(jsonResponse["description"]);
        return true;
        } else {
          Fluttertoast.showToast(
              msg: "${jsonResponse["description"]}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white70,
              textColor: Colors.black,
              fontSize: 16.0);
          return false;
        }
      }else {
        Fluttertoast.showToast(
            msg: "An error has occurred!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white70,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      return false;
    }

  }

  void onEnd() {
    print('onEnd');
  }

  Future<bool> makeCodeConfirmationRequest(context) async{

    List<String> codeCredentials = [
      phoneNum.value.replaceAll("+", ""),
      codeController.text,
    ];

    var head = {
      "Accept": "application/json",
      "content-type":"application/json"
    };

    print("sssss");
    print("${codeCredentials[0]}");
    print("${codeCredentials[1]}");

    if (codeCredentials[1].isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter the code",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0);
      return false;
    } else {
      var response = await http.post(Uri.parse(baseURL + "/api/ConfirmPhoneNumber"), body: jsonEncode(
        {
          "UserName": "${codeCredentials[0]}",
          "Code": codeCredentials[1]
        },
      ), headers: head
      ).timeout(const Duration(seconds: 20), onTimeout:() {
        Fluttertoast.showToast(
            msg: "The connection has timed out, Please try again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white70,
            textColor: Colors.black,
            fontSize: 16.0
        );
        throw TimeoutException('The connection has timed out, Please try again!');
      });

      if(response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if(jsonResponse["status"]){
          Navigator.pop(context, 'OK');
          //add the installation to promoter
          Fluttertoast.showToast(
              msg: "Everything done!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white70,
              textColor: Colors.black,
              fontSize: 16.0
          );
          saveInstallationForPromoters(promoterId);
          return true;

        } else{
          Fluttertoast.showToast(
              msg: "${jsonResponse["description"]}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white70,
              textColor: Colors.black,
              fontSize: 16.0);
          return false;

        }
      } else{
        Fluttertoast.showToast(
            msg: "Error ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white70,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      return false;
    }

  }

  //
  Future saveInstallationForPromoters(String promoterIdN) async {

    print('from url =............== $promoterIdN');

    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/AddPromoterInstallation'));
    request.body = json.encode({
      "PromoterID": promoterIdN
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

}