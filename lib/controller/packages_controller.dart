import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Assistants/globals.dart';
import '../Data/current_data.dart';
class PackagesController extends GetxController {
  var allPackages =[].obs;
  var myPackages =[].obs;
  var hasAPackage =false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllPackages();
    getMyPackages();
  }

  Future getAllPackages()async{
    var data;
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$baseURL/api/ListPackage'));
    request.body = json.encode({
      "PageNumber": 1,
      "PageSize": 11
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      data = json['description'];
      allPackages.value = data;
      print('AllPackages ====== $data');
      update();
    }
    else {
      print(response.reasonPhrase);
      print("Error in get all packages");
    }

  }

  Future getMyPackages()async {
    var data;

    var headers = {
      'Authorization': 'Bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseURL/api/ListMyPackages'));
    request.body = json.encode({
      "userId": user.id,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      data = json['description'];
      if(data.length > 0){
        hasAPackage.value =true;
      }else{
        hasAPackage.value =false;
      }
      myPackages.value = data;
      print('My Packages ====== $data');
      update();
    }
    else {
      print(response.reasonPhrase);
      print("Error in get My Packages");
    }



  }
  Future<bool> addPackage({required double value, required String id, required String invoiceId , required bool isCard}) async {
    print("is card  $isCard");
    print("package $id");
    print("package invoice id $invoiceId");
    print("package price $value");
    var headers = {
      'Authorization': 'Bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseURL/api/AddPackageUser'));
if(isCard){
  request.body = json.encode({
    "PackageID": id,
    "invoiceId":invoiceId,
    "paymentGateway":"Visa/Mastercard",
    "invoiceValue":value

  });
}else{
  request.body = json.encode({
    "PackageID": id,
    "invoiceValue":value

  });
}
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var jsonR = jsonDecode(await response.stream.bytesToString());

    print('package res $jsonR');
    if (jsonR['status']==true) {
      Fluttertoast.showToast(msg: 'Packages added successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0
      );
      return true;
    }
    else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(msg: 'Something went wrong!!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0
      );
      return false;
    }
  }
}