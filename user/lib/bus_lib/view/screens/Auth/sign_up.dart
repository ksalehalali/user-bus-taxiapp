import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../pages/login/get_started.dart';
import '../../../Assistants/globals.dart';
import '../../../controller/sign_up_controller.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final SignUpController signUpController= Get.find();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//  final TextEditingController controller = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'KW');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background/WhatsApp Image 2022-10-02 at 12.55.00 PM.jpeg"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [

            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [

                          InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                              signUpController.phoneNum.value = number.phoneNumber!;

                            },
                            onInputValidated: (bool value) {
                              print(value);
                            },
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            maxLength: 8,
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: const TextStyle(color: Colors.black87),
                            textStyle: const TextStyle(color: Colors.black87),
                            inputDecoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black87,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            initialValue: number,
//                            textFieldController: controller,
                            formatInput: false,
                            keyboardType:
                            const TextInputType.numberWithOptions(signed: true, decimal: true),
                            inputBorder: OutlineInputBorder(),
                            onSaved: (PhoneNumber number) {
                              print('On Saved: $number');
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          // PASSWORD TEXT FIELD
                          TextField(
                            controller: signUpController.passwordController,
                            style: TextStyle(color: Colors.black87),
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black87,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.black87),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),

                          const SizedBox(
                            height: 12,
                          ),
                          // PASSWORD TEXT FIELD
                          TextField(
                            controller: signUpController.nameController,
                            style: TextStyle(color: Colors.black87),
                            obscureText: false,
                            onChanged: (val){
                              name = val;
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black87,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.black87),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),

                          const SizedBox(
                            height: 12,
                          ),
                          // PASSWORD TEXT FIELD
                          TextField(
                            controller: signUpController.emailController,
                            style: TextStyle(color: Colors.black87),
                            onChanged: (val){
                              email = val;
                            },
                            obscureText: false,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black87,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.black87),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SIGN UP TEXT
                              const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              // SIGN UP BUTTON
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child:  Obx(() => IconButton(
                                  color: Colors.white,
                                  onPressed: () async{
                                    String pattern =
                                        r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])*$";
                                    RegExp regex = RegExp(pattern);
                                    if(regex.hasMatch(signUpController.emailController.text)) {
                                      validatePassword(signUpController.passwordController.text);
                                    }else{
                                      Get.snackbar("Wrong Email_txt".tr, "Please put correct email address");
                                    }
                                  },
                                  icon: !signUpController.isSignUpLoading.value ?
                                  Icon(Icons.arrow_forward,
                                  ):
                                  const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          // NAV LOGIN BUTTON
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.to(Login());
                                },
                                style: const ButtonStyle(),
                                child: const Text(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black87,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void validatePassword(String value)async {
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      _showDialogBoxWrongPassword();
    } else {
      if (!regex.hasMatch(value)) {
        _showDialogBoxWrongPassword();
      } else {
        signUpController.isSignUpLoading.value = true;
        await signUpController.makeSignUpRequest(context);
        signUpController.isSignUpLoading.value = false;
      }
    }
  }

  _showDialogBoxWrongPassword() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: const Text('Wrong Password'),
      ),
      content:  Text('Password must contain :\n > A uppercase character\n > A lowercase character\n > A number\n > A special character( ! @ # \$ & * ~ )\n > Minimum 8 characters ',textAlign: TextAlign.left ,style: TextStyle()),
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
}