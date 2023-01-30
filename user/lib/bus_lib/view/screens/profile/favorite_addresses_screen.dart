import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/lang_controller.dart';
import '../../../controller/personal_information_controller.dart';
import '../../../controller/trip_controller.dart';

class FavoriteAddressesScreen extends StatefulWidget {
  const FavoriteAddressesScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteAddressesScreen> createState() => _FavoriteAddressesScreenState();
}

class _FavoriteAddressesScreenState extends State<FavoriteAddressesScreen> {
  final TripController trips = Get.find();
  final LangController langController = Get.find();
  PersonalInformationController personalInfoController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: InkWell(
          onTap: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back,color: Colors.blue[900],size: 32,),
        ),
        title: Text('yourFavoriteAddresses_txt'.tr,style: TextStyle(color: Colors.blue[900]),),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Addresses_txt'.tr,style: TextStyle(color: Colors.blue[900],fontSize: 16,fontWeight: FontWeight.bold),),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(()=> Text('${personalInfoController.myFavAddresses.length}',style: TextStyle(color: Colors.blue[900],fontSize: 16,fontWeight: FontWeight.bold),)),
                  ),
                ],
              ),
            ),
            Container(
              height: screenSize.height- 140,
              width: screenSize.width,
              child: FutureBuilder(
                future:personalInfoController.getMyAddresses() ,
                builder: (context,data)=> Obx(()=> ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: personalInfoController.myFavAddresses.length,
                    itemBuilder: (context,index)=>Column(
                      children: [
                        Divider(thickness:1,height:0.0),
                        ListTile(
                          title:       Row(
                            children: [Text('name_txt'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black)),
                              Text( ": ${personalInfoController.myFavAddresses[index]['name']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Text( " ${personalInfoController.myFavAddresses[index]['desc']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black)),
                          ) ,
                          trailing: InkWell(
                            onTap: (){
                             showDialogBoxDeleteFavAddress(index);
                            },
                            child:Icon(Icons.delete_forever)
                          ),

                        ),

                      ],
                    ))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showDialogBoxDeleteFavAddress(int index) => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title:  Text('Address delete_txt'.tr),
      content: langController.appLocal =="en"? Text('Your Address ${personalInfoController.myFavAddresses[index]['name']} will be deleted_txt'.tr):Text(' سوف يتم حذف  ${personalInfoController.myFavAddresses[index]['name']}  '),
      actions: <Widget>[

        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Confirm_txt'.tr);
          },
          child:  Text('Close_txt'.tr),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Confirm_txt'.tr);
           var delete = await personalInfoController.deleteMyFavAddress(personalInfoController.myFavAddresses[index]['id']);
           if(delete) {

             //notify the user address deleted
             CupertinoAlertDialog(
               title: const Text('Address deleted'),
               content: const Text('Your address deleted'),
               actions: <Widget>[
                 TextButton(
                   onPressed: () async {
                     Navigator.pop(context, 'Ok');
                   },
                   child: const Text('Ok'),
                 ),
               ],
             );
           }
          },
          child:  Text('Confirm_txt'.tr),
        ),
      ],
    ),
  );
}
