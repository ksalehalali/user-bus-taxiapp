import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Assistants/globals.dart';
import '../../../Data/packages_data.dart';
import '../../../controller/lang_controller.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  var screenSize = Get.size;
  final LangController langController = Get.find();

  @override
  Widget build(BuildContext context) {

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
                    child: Text('Bus Pass_txt'.tr,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    height: 2,
                    width: screenSize.width /5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],

                    ),
                  ),

                ],
              ),
              SizedBox(height: 18,),

              Container(
                height: screenSize.height-screenSize.height *0.2-20,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: packages.length,

                    itemBuilder: (context,index)=>InkWell(
                      onTap: (){
                        Get.dialog(
                          Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Center(
                              child: Container(
                                height: screenSize.height *0.4,
                                width: screenSize.width *0.8,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                          onTap: (){
                                            Navigator.of(context).pop();
                                          },
                                          child: Icon(Icons.close_sharp,size: 35,color: Colors.redAccent,)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(  packages[index]['name'],overflow:TextOverflow.ellipsis,maxLines: 1
                                        ,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                                    ),
                                    SizedBox(height: 18.0,),

                                     Text('Unlimited travel on all routes_txt'.tr),
                                    const SizedBox(height: 118.0,),

                                    ElevatedButton(onPressed:(){

                                    },
                                      style: ButtonStyle(
                                        backgroundColor:MaterialStateProperty.all(Colors.blue[800]),
                                        foregroundColor: MaterialStateProperty.all(routes_color),
                                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12,horizontal: 22)),
                                      ) ,
                                      child:Text('BUY NOW_txtBtn'.tr,overflow:TextOverflow.ellipsis,maxLines: 1
                                      ,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),), ),

                                  ],
                                )),
                              ),
                            ),
                          )
                        );

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
                                  SizedBox(width: 14,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      SizedBox(
                                        width: 220.0,
                                        child: Text(  packages[index]['name'],overflow:TextOverflow.ellipsis,maxLines: 1
                                          ,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [langController.appLocal=="en"?
                                              Text("Expiry Date : ${DateFormat('yyyy-MM-dd  HH:mm :ss').format(packages[index]['expiryDate'])}",style: TextStyle(color: Colors.black,),):
                                            Text("${DateFormat('yyyy-MM-dd  HH:mm :ss').format(packages[index]['expiryDate'])}تاريخ الانتهاء: ",style: TextStyle(color: Colors.black,),),
                                              SizedBox(height: 12.0,),
                                              langController.appLocal=="en"?Text("Price : ${packages[index]['price'].toStringAsFixed(3)}",style: TextStyle(color: Colors.black,),):
                                              Text("${packages[index]['price'].toStringAsFixed(3)}السعر : ",style: TextStyle(color: Colors.black,),),

                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  //Text('Route : ${trips.trips[index]['rout']}'),
                                  Column(
                                    children: [
                                      RichText(text: TextSpan(
                                          children: [
                                            TextSpan(text: 'Routes : _txt'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black)),
                                            TextSpan(text: packages[index]['routes'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),

                                          ]
                                      )),
                                      const SizedBox(height: 8,),

                                      RichText(text: TextSpan(
                                          children: [langController.appLocal=="en"?
                                            TextSpan(text: '${packages[index]['duration/days'].toString()} Days',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.green)):
                                          TextSpan(text: '${packages[index]['duration/days'].toString()} الايام ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.green)),

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
            ],
          ),
        ),
      ),
    );
  }
}
