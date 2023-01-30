
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Assistants/globals.dart';
import '../../controller/lang_controller.dart';
import '../../controller/personal_information_controller.dart';
import '../../model/fav_address.dart';
import '../../model/location.dart';

addFavoriteAddress(BuildContext context, screenSize ,String address, LocationModel location){
  TextEditingController addressesNameController =  TextEditingController();
  final LangController langController = Get.find();
  final PersonalInformationController personalInformationController = Get.find();

  Get.dialog(
    Scaffold(
      backgroundColor: Colors.transparent,

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Center(
              child: Container(

                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child:Column(
                  crossAxisAlignment:langController.appLocal == "en"
                      ? CrossAxisAlignment.end:CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.close_sharp,
                            size: 40,
                            color: Colors.redAccent,
                          )),
                    ),
                    SizedBox(
                      height:14.0,
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: screenSize.width * 0.5,
                        height:48,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0,left: 8),
                          child: TextField(
                            controller: addressesNameController,

                            decoration: InputDecoration(
                              hintText: "Enter name (Home,Work...)_txt".tr,
                              hintTextDirection: TextDirection.ltr,
                              hintStyle: TextStyle(fontSize: 14),
                              // focusedBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: routes_color, width: 1.0),
                              //   borderRadius: BorderRadius.circular(4),
                              // ),
                              //
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(4),
                            //  ),
                            ),

                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 16.0,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:langController.appLocal =="en" ?
                      Text("Address:\n$address",overflow:TextOverflow.ellipsis,maxLines: 3,textAlign: TextAlign.left,textDirection:TextDirection.ltr ,style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),)
                      :Text("العنوان:  \n$address",overflow:TextOverflow.ellipsis,maxLines: 3,style: TextStyle(fontSize:16,fontWeight: FontWeight.bold,color: Colors.black87),),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                  Align(
                    alignment: Alignment.center,
                    child:ElevatedButton(
                      onPressed: ()async{
                    if(addressesNameController.text.length > 2){
                      var addAddress =await  personalInformationController.addMyFavAddresses(FavoriteAddress(name: addressesNameController.text, address: address, location: location, createdDate: DateTime.now().toString(), id: ''));
                      if(addAddress == true){
                        Navigator.of(context).pop();
                        Get.snackbar("Done", "Your address saved");
                        print("Done");
                      }
                      print("Done2");

                    }else{
                      Get.snackbar("Wrong", "Name too short");
                    }
                    },

                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(routes_color),
                        foregroundColor:
                        MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                                vertical: 6, horizontal: 22)),
                      ),
                      child: Text('Save_txt'.tr),
                    ),),
                    SizedBox(
                      height:8.0,
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    )
  );
}