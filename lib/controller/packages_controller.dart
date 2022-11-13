import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Assistants/globals.dart';
import '../Data/current_data.dart';
class PackagesController extends GetxController {
  var allPackages =[].obs;
  var myPackages =[].obs;

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
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJOYW1lIjoiY29tcEtHTCIsIlJvbGUiOiJDb21wYW55IiwiZXhwIjoxNjY4MzM1ODQ0LCJpc3MiOiJJbnZlbnRvcnlBdXRoZW50aWNhdGlvblNlcnZlciIsImF1ZCI6IkludmVudG9yeVNlcnZpY2VQb3RtYW5DbGllbnQifQ.z61RGXbakb63Ny2mhhynbIvqVF-SHxm9UekmDNNd06A',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseURL/api/ListPackageByUserIdForCompany'));
    request.body = json.encode({
      "userId": "b692c12c-c4ba-4cee-b092-ac3cb276dd38"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      data = json['description'];
      myPackages.value = data;
      print('My Packages ====== $data');
      update();
    }
    else {
      print(response.reasonPhrase);
      print("Error in get My Packages");
    }


    Future<bool> addPackage(String id) async {
      var headers = {
        'Authorization': 'Bearer ${user.accessToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST', Uri.parse('$baseURL/api/AddPackageUser'));
      request.body = json.encode({
        "PackageID": id
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        return true;
      }
      else {
        print(response.reasonPhrase);
        return false;
      }
    }
  }}