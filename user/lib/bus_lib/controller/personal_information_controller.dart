import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Assistants/globals.dart';
import '../Data/current_data.dart';
import '../model/fav_address.dart';

class PersonalInformationController extends GetxController {


  final nameController = new TextEditingController();
  final emailController = new TextEditingController();

  var profilePicture = File("").obs;
  var profilePictureUrl = "".obs;

  var nameHint = "username".obs;
  var emailHint = "example@example.com".obs;
  var token = "".obs;
  var username = "".obs;
  var isSaveLoading = false.obs;
  var myFavAddresses =[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    fetchUserLoginPreference();
  }

  @override
  onClose() {
    print("Closssssssssssseeee");
//    nameController.text = "";
//    nameController.dispose();
//    emailController.text = "";
//    emailController.dispose();
  }

  //delete account
  void deleteMyAccount(String id) async {

    print('from delete');

    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('https://route.click68.com/api/DeleteAccount'));
    request.body = json.encode({
      "id": id
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

  //get personal_information
  Future<void> fetchPersonalInformation(token) async{
    var head = {
      "Authorization": "Bearer $token",
    };

    final url = await http.get(Uri.parse(baseURL + '/api/MyProfile'), headers: head);
    var response = jsonDecode(url.body);
    print(response);

    if(response["status"]) {
      print(response["description"]["name"]);
      user.name = response["description"]["name"];
      if(response["description"]["name"] != null)
      nameHint.value = response["description"]["name"];
      if(response["description"]["email"] != null)
      emailHint.value = response["description"]["email"];
      if(response["description"]["image"] != null)
      profilePicture.value = File("$baseURL/${response["description"]["image"]}");
      profilePictureUrl.value = "$baseURL/${response["description"]["image"]}";
      print("SSSSS     $baseURL/${profilePicture.value}");
    }
  }


  void editInfoConfirmation(editedImage) async{
    print("${nameController.text != ""} ${emailController.text != ""} ${editedImage.path != ""}");
    if(nameController.text != "" || emailController.text != "" || editedImage.path != "") {
      await editPersonalInformation();
      await editProfilePictureInformation(editedImage);
    } else {
      Fluttertoast.showToast(
          msg: "No Modifications has been made",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0
      );
    }

  }

  Future<void> editPersonalInformation() async{

    var head = {
      "Accept": "application/json",
      "content-type":"application/json",
      "Authorization": "Bearer $token"
    };

    var jsonBody =  {
      "UserName": "${username.value}",
    };

    if(nameController.text != "") {
      jsonBody["Name"] = nameController.text;
    }

    if(emailController.text != "") {
      jsonBody["Email"] = emailController.text;
    }

    var response = await http.post(Uri.parse(baseURL + "/api/EditeUser"), body: jsonEncode(
      jsonBody,
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

    print(response.statusCode);
    print("body ${response.body}");


    if(response.statusCode == 200){
      if(nameController.text != "") {
        nameHint.value = nameController.text;
      }
      if(emailController.text != "") {
        emailHint.value = emailController.text;
      }

      Fluttertoast.showToast(
          msg: "Profile Information updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0
      );
      nameController.clear();
      emailController.clear();
      Get.back();
    }

  }

  Future<void> editProfilePictureInformation(editedImage) async{
    final url = Uri.parse(baseURL + "/api/EditeImage");
    var request = http.MultipartRequest(
        'POST', url
    );
    request.headers['Content-type'] ='multipart/form-data';
    request.headers["Authorization"] = "Bearer $token";

    print("${editedImage.path}");

    request.files.add(
      http.MultipartFile('Image',
          File(editedImage.path).readAsBytes().asStream(),
          File(editedImage.path).lengthSync(),
          filename: editedImage.path.split("/").last),
    );

    try {
      var response = await request.send();
      final res = await http.Response.fromStream(response);
      print("ressss: ${res.body.toString()}" );
      print("${res.statusCode}");

      Map<String, dynamic> dep = jsonDecode(utf8.decode(res.bodyBytes));

    }
    catch(error) {
      print("ccccatch errrrrrrrrrrrror " + error.toString());
    }

  }

  Future<void> fetchUserLoginPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? s = await prefs.getString('id');
    username.value = (await prefs.getString('username'))!;
    token.value = (await prefs.getString('token'))!;


    fetchPersonalInformation(token);
  }

  //my addresses
  Future<bool> addMyFavAddresses(FavoriteAddress address) async {
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('Post', Uri.parse(baseURL +'/api/AddUserLocation'));
    request.body = json.encode({
      "Name": address.name,
      "Desc": address.address,
      "Latitude": address.location.latitude,
      "Longitude": address.location.longitude,

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

  Future getMyAddresses() async {

    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('Get', Uri.parse(baseURL +'/api/ListLocationByUser'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var json = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200 &&json['status'] ==true) {
      print("res ====----==== ${json}");
      myFavAddresses.value = json["description"];
      return myFavAddresses;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }

  }

  Future deleteMyFavAddress(String addressId) async {
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(baseURL +'/api/DeletUserLocation'));
    request.body = json.encode({
      "id":addressId,

    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var jsonResponse = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200 &&jsonResponse['status'] ==true) {
      print("res ====-delete---==== ${jsonResponse}");
      Fluttertoast.showToast(
          msg: "delete successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0
      );
      getMyAddresses();
      return true;
    }
    else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(
          msg: "Delete failed",
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