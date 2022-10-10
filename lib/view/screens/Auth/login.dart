import 'dart:io';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:routes/view/screens/Auth/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Assistants/globals.dart';
import '../../../Data/current_data.dart';
import '../../../controller/login_controller.dart';
import '../../../controller/profile_pic_controller.dart';
import 'confirm_number.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final profilePicController = Get.put(ProfilePicController());
  final LoginController loginController =  Get.find();

  bool chooseCamera = false;
  PhoneNumber number = PhoneNumber(isoCode: 'KW');

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print(DateFormat('yyyy-MM-dd-HH:mm-ss').format(DateTime.now()));
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background/WhatsApp Image 2022-10-02 at 12.55.00 PM.jpeg"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.35
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  margin: EdgeInsets.only(left: 35, right: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // USERNAME TEXT FIELD
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
//                              SizedBox(width: 28,),
                      Container(
                        padding: EdgeInsets.only(left: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            print(number.phoneNumber);
                            loginController.phoneNum.value = number.phoneNumber!;
                          },
                          onInputValidated: (bool value) {
                            print(value);
                          },
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          maxLength: 8,
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: TextStyle(color: Colors.black),
                          textStyle: TextStyle(color: Colors.black),
                          inputDecoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          initialValue: number,
//                            textFieldController: controller,
                          formatInput: false,
                          keyboardType:
                          TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputBorder: OutlineInputBorder(),
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                        // PASSWORD TEXT FIELD
                      TextField(
                        controller: loginController.passwordController,
                        style: TextStyle(),
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          hintText: "Password",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: routes_color, width: 1.0),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // LOGIN PROCEED
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          CircleAvatar(
                            radius: 30,
                            backgroundColor: routes_color,
                            child: Obx(() => IconButton(
                                color: Colors.white,
                                onPressed: () async{
                                  //FirebaseDynamicLinkService.createDynamicLink(false, 'user.id');

                                  // TODO: login API
                                 bool connected = await loginController.isConnected();
                                 if (connected) {
                                   loginController.isLoginLoading.value = true;
                                   await loginController.makeLoginRequest();
                                   loginController.isLoginLoading.value = false;
                                 }else{
                                   _showDialogBoxNoneConnection();
                                 }

                                },
                                icon: !loginController.isLoginLoading.value ?
                                Container(
                                    child: Icon(
                                      Icons.arrow_forward,
                                    )
                                ):
                                Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                                //icon: loginController.loginIcon.value
                            ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height:screenSize.height *0.1.h-60,
                      ),

                      // SIGN UP / FORGOT PASSWORD SECTION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {

                              Navigator.push(
                                this.context,
                                MaterialPageRoute(builder: (context) => new SignUp()),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: routes_color,
                                  fontSize: 18),
                            ),
                            style: ButtonStyle(),
                          ),
                          // FORGOT PASSWORD
                          TextButton(
                              onPressed: () {
                                Get.to(ConfirmNumber());
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: routes_color,
                                  fontSize: 18,
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height:screenSize.height *0.1.h-20,
                      ),
                      //pay offline button
                      Align(
                        alignment:Alignment.bottomCenter,
                        child: OutlinedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:MaterialStateProperty.all(routes_color.withOpacity(0.9)),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w)),

                          ) ,
                          onPressed: ()async{
                            createQRCodeToPay();
                              // Fluttertoast.showToast(
                              //     msg: "msg_offline".tr,
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     gravity: ToastGravity.CENTER,
                              //     timeInSecForIosWeb: 1,
                              //     backgroundColor: Colors.white70,
                              //     textColor: Colors.black,
                              //     fontSize: 16.0.sp);

                          }, label: Text(
                          "Pay offline_btn".tr,
                          style: TextStyle(
                              fontSize: 13.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold

                          ),
                        ), icon: Icon(Icons.qr_code), ),
                      ),

                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  _showDialogBoxNoneConnection() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('No Connection'),
      content: const Text('Please check your internet connectivity'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Cancel');

          },
          child: const Text('OK'),
        ),
      ],
    ),
  );

  Future createQRCodeToPay()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int code = Random().nextInt(999999);
    String codeDate = DateFormat('yyyy-MM-dd-HH:mm-ss').format(DateTime.now());

    print("{\"lastToken\":\"${prefs.getString('lastToken')}\",\"paymentCode\":\"$codeDate${prefs.getString('lastPhone')!}\"}");

    return Get.dialog(Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          height:360.h,
          color: Colors.white,
          child: Center(
            child: QrImage(
              data: "{\"lastToken\":\"${prefs.getString('lastToken')}\",\"paymentCode\":\"$codeDate${prefs.getString('lastPhone')!}\"}",
              version: QrVersions.auto,
              size: 250.0.sp,
            ),
          ),
        )
    ));
  }
}
