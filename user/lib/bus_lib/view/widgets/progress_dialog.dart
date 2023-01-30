
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Assistants/globals.dart';

class ProgressDialog extends StatelessWidget {
  String? message;

  ProgressDialog({Key? key,this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.blue[100],
      child: Container(
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(width: 6.0,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              SizedBox(width: 26.0,),
              Text(message!,style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black
              ),)
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressDialogShowPayment extends StatelessWidget {
  String? message;

  ProgressDialogShowPayment({Key? key,this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.blue[100],
      child: Container(
        height:330,
        margin: EdgeInsets.all(12.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text('Your Trip Payed',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 8.0,),
                Text('Route',style: TextStyle(fontSize: 14),),
                //Text(user.totalBalance!.toStringAsFixed(3),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)

                SizedBox(height: 12.0,),
                Text('ticket price cut:',style: TextStyle(fontSize: 14),),
                //Text(paymentSaved.value!.toStringAsFixed(3),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                SizedBox(height: 8.0,),
                Text('your balance :',style: TextStyle(fontSize: 14),),
                //Text(user.totalBalance!.toStringAsFixed(3),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                SizedBox(height: 20.0,),
                Center(child: Icon(Icons.done,size: 66,color: Colors.green[800],))
              ],
            )
        ),
      ),
    );
  }
}

class DialogHelper {
  //show error dialog
  static void showErroDialog({String title = 'Error', String? description = 'Something went wrong'}) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headline4,
              ),
              Text(
                description ?? '',
                style: Get.textTheme.headline6,
              ),
              ElevatedButton(
                onPressed: () {
                  if (Get.isDialogOpen!) Get.back();
                },
                style: ElevatedButton.styleFrom(
                    maximumSize: Size(120, 140),
                    minimumSize: Size(120, 30),
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    alignment: Alignment.center),
                child: Text('Okay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //show toast
  //show snack bar
  //show loading
  static void showLoading([String? message]) {

    Get.dialog(
      Dialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent.withOpacity(0.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              // Text(message ?? 'Loading...'),
              SizedBox(
                width: 80,
                height: 80,

                child: Center(
                  child: Image.asset(
                    'assets/animation/Logo animated-loop-fast.gif',
                    fit: BoxFit.fill,
                    color: routes_color,
                  ),
                )
              )         ],
          ),
        ),
      ),
    );
  }

  //hide loading
  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }
}