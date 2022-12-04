import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../Assistants/globals.dart';
import '../../../controller/lang_controller.dart';
import '../../../controller/packages_controller.dart';
import '../../../controller/payment/my_fatoorh_checkout.dart';
import '../../../helper/constants.dart';

class MyPackagesScreen extends StatefulWidget {
  const MyPackagesScreen({Key? key}) : super(key: key);

  @override
  State<MyPackagesScreen> createState() => _MyPackagesScreenState();
}

class _MyPackagesScreenState extends State<MyPackagesScreen> {
  final LangController langController = Get.find();
  final PackagesController packagesController =  Get.find();@override
  void initState() {
    // TODO: implement initState
    super.initState();
    packagesController.getMyPackages();
  }
  @override
  Widget build(BuildContext context) {
    var screenSize =MediaQuery.of(context).size;

    return Container(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [

              Row(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.close_sharp,
                            size: 44,
                            color: Colors.redAccent,
                          ),
                        )),
                  ),

                ],
              ),
              const SizedBox(height: 8,),
              Column(
                children: [
                  Center(
                    child: Text('Packages_txt'.tr,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height:4),
                  Container(
                    height: 2,
                    width: screenSize.width /4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],

                    ),
                  ),

                ],
              ),
              SizedBox(height: 18,),

              Container(
                height: screenSize.height-screenSize.height *0.2-20,
                child: Obx(()=> ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: packagesController.myPackages.length,

                      itemBuilder: (context,index)=>InkWell(
                        onTap: (){

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [

                              Container(
                                child: Row(
                                  children: [
                                    Container(padding: EdgeInsets.zero,
                                      height: screenSize.height *0.1,
                                      width: 3 ,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],

                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        SizedBox(
                                          width: screenSize.width *0.4 ,
                                          child: Text(  packagesController.myPackages[index]['packageKind'],overflow:TextOverflow.ellipsis,maxLines: 1
                                            ,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                                        ),
                                        SizedBox(height: 8.0,),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                langController.appLocal=="en"?
                                                Text("Expiry Date : ${packagesController.myPackages[index]['activationExpiryDate']}",style: TextStyle(color: Colors.black,),):
                                                Text("تاريخ الانتهاء: ${packagesController.myPackages[index]['activationExpiryDate']}",style: TextStyle(color: Colors.black,),),
                                                SizedBox(height: 12.0,),
                                                // langController.appLocal=="en"?Text("Price : ${packagesController.allPackages[index]['price'].toStringAsFixed(3)}",style: TextStyle(color: Colors.black,),):
                                                // Text("${packagesController.allPackages[index]['price'].toStringAsFixed(3)}السعر : ",style: TextStyle(color: Colors.black,),),

                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    //Text('Route : ${trips.trips[index]['rout']}'),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        RichText(text: TextSpan(
                                            children: [
                                              TextSpan(text: 'Activation Date: _txt'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black)),
                                              TextSpan(text: " ${packagesController.myPackages[index]['activationDate']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.green[800])),

                                            ]
                                        )),
                                        const SizedBox(height: 8,),

                                        RichText(text: TextSpan(
                                            children: [
                                              TextSpan(text: 'Remaining : _txt'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.green)),
                                              TextSpan(text: ' ${packagesController.myPackages[index]['duration']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.green)),

                                            ]
                                        )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8,),
                              Container(
                                height: 2,
                                width: screenSize.width ,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],

                                ),
                              ),

                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
