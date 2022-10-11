import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../Assistants/globals.dart';
import '../Data/current_data.dart';
import '../view/screens/Auth/login.dart';
import '../view/screens/main_screen.dart';


class LoginController extends GetxController {
  var isLoginLoading = false.obs;
  var loginIcon = new Container(
      child: Icon(
        Icons.arrow_forward,
      )
  ).obs;

  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();
  RxString phoneNum = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserLoginPreference();
  }
  @override
  void onClose() {
    super.onClose();
    usernameController.dispose();
    passwordController.dispose();
  }


  Future<bool> isConnected()async{
    bool connected = false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      user.isConnected = true;
      print('mobile.......');
      connected = true ;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      user.isConnected = true;

      print('wifi.......');
      connected =true;

    }else if (connectivityResult == ConnectivityResult.none) {
      // I am connected to a wifi network.
      print('none.......');
      connected = false;
      user.isConnected = false;

    }
    return connected;
  }

  //logout
  Future<void> logout()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastToken', prefs.getString('token')!);
    await prefs.setString('lastPhone', prefs.getString('phoneNumber')!);


    prefs.remove('token');
    prefs.remove('username');
    prefs.remove('id');
    prefs.remove('phoneNumber');

    print("last token :: ${prefs.getString('lastToken')}");
    print("last phone number :: ${prefs.getString('lastPhone')}");

    Get.offAll(()=>Login());
  }

  //login
  Future<void> makeLoginRequest () async{
//  isLoginLoading.value = true;
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(" 0000000000 FCM token: " + fcmToken!);
    loginIcon.value = Container(
      child: CircularProgressIndicator(),
    );

    List<String> loginCredentials = [
      phoneNum.value.replaceAll("+", ""),
//      "96551027146",
      passwordController.text
    ];

    print("IIIINNNFFFOOO ${loginCredentials[0]} : ${loginCredentials[1]}");

    var head = {
      "Accept": "application/json",
      "content-type":"application/json"
    };

    if (loginCredentials[0].isEmpty || loginCredentials[1].isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill all the required information",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0);
    } else {
      var response = await http.post(Uri.parse(baseURL + "/api/Login"), body: jsonEncode(
        {
          "UserName": loginCredentials[0],
          "Password": loginCredentials[1],
          "FCMToken":fcmToken
        },
      ), headers: head
      ).timeout(const Duration(seconds: 10), onTimeout:(){
        Fluttertoast.showToast(
            msg: "The connection has timed out, Please try again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white70,
            textColor: Colors.black,
            fontSize: 16.0
        );
        Get.offAll(()=>Login());
        throw TimeoutException('The connection has timed out, Please try again!');
      });

      if(response.statusCode == 500) {
        Fluttertoast.showToast(
            msg: "Error 500",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white70,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      else if (response.statusCode == 200){
        var jsonResponse = json.decode(response.body);
        print('user info ::====::: $jsonResponse');
        if(jsonResponse["status"]){
          print(jsonResponse["description"]);
          print('==================================');
          print("my new token is ::: ${jsonResponse["description"]['token']}");
          user.id = jsonResponse["description"]['id'];
          // TODO: store token in shared preferences then navigate to the following screen
          storeUserLoginPreference(jsonResponse["description"]["token"], jsonResponse["description"]["userName"], loginCredentials[1], jsonResponse["description"]["id"], jsonResponse["description"]["phoneNumber"]);
          user.accessToken = jsonResponse["description"]["token"];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('lastToken', jsonResponse["description"]["token"]);
          await prefs.setString('lastPhone', jsonResponse["description"]["phoneNumber"]);


          Get.offAll(MainScreen(indexOfScreen: 0,));
          phoneNum.value = "";

          passwordController.text = "";

        } else {
          Fluttertoast.showToast(
              msg: "Username and password do not match!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white70,
              textColor: Colors.black,
              fontSize: 16.0);
        }
      }
    }
    loginIcon.value = Container(
      child: Icon(
        Icons.arrow_forward,
      ),
    );

//    isLoginLoading.value = false;
  }

  Future<void> makeAutoLoginRequest (username, password) async{

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(" 0000000000 FCM token: " + fcmToken!);

    var head = {
      "Accept": "application/json",
      "content-type":"application/json"
    };

    var response = await http.post(Uri.parse(baseURL + "/api/Login"), body: jsonEncode(
      {
        "UserName": username,
        "Password": password,
        "FCMToken":fcmToken
      },
    ), headers: head
    ).timeout(const Duration(seconds: 10), onTimeout:(){
      Fluttertoast.showToast(
          msg: "The connection has timed out, Please try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0
      );
      Get.offAll(()=>Login());

      throw TimeoutException('The connection has timed out, Please try again!');
    });

    if(response.statusCode == 500) {
      Fluttertoast.showToast(
          msg: "Error 500",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0);
      Get.to(()=>Login());

    }
    else if (response.statusCode == 200){
      var jsonResponse = json.decode(response.body);
      print('user info ::==auto login==::: $jsonResponse');

      if(jsonResponse["status"]){
        print('==================================');
        user.id = jsonResponse["description"]['id'];
        // TODO: store token in shared preferences then navigate to the following screen
        storeUserLoginPreference(jsonResponse["description"]["token"], jsonResponse["description"]["userName"], password, jsonResponse["description"]["id"],jsonResponse["description"]["phoneNumber"]);
        user.accessToken = jsonResponse["description"]["token"];
        user.name = jsonResponse["description"]["name"];
        user.phone =jsonResponse["description"]["phoneNumber"];
        print("new token  ${jsonResponse["description"]["token"]}");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('lastToken', jsonResponse["description"]["token"]);
        await prefs.setString('lastPhone', jsonResponse["description"]["phoneNumber"]);

        //call func to save installation
        //if(promoterId!="")saveInstallationForPromoters(promoterId);

     Timer(const Duration(milliseconds: 200), (){
       Get.to(MainScreen(indexOfScreen: 0,));
     });

      } else {
        Fluttertoast.showToast(
            msg: "Username and password do not match!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white70,
            textColor: Colors.black,
            fontSize: 16.0);
       Timer(Duration(milliseconds: 200),(){
         Get.to(()=>Login());
       });

      }
    }


  }
  //
  Future saveInstallationForPromoters(String promoterIdN) async {

    print('from url =............== $promoterIdN');

    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(baseURL + '/api/AddPromoterInstallation'));
    request.body = json.encode({
      "PromoterID": promoterIdN
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('save installation for p done ---');
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<void> storeUserLoginPreference(token, username, password, id,phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);

    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setString('id', id);
    await prefs.setString('phoneNumber', phone);

  }

  Future<void> getUserLoginPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user.accessToken =await prefs.getString('token');
    user.name =await prefs.getString('username');
    user.id =  await prefs.getString('id');
    user.phone =  await prefs.getString('phoneNumber');

  }


}
