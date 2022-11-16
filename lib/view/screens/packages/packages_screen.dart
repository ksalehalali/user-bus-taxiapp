import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../Assistants/globals.dart';
import '../../../controller/lang_controller.dart';
import '../../../controller/packages_controller.dart';
import '../../../controller/payment/my_fatoorh_checkout.dart';
import '../../../helper/constants.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final LangController langController = Get.find();
  final PackagesController packagesController =  Get.find();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
                        child:  Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.close_sharp,
                            size: 44.sp,
                            color: Colors.redAccent,
                          ),
                        )),
                  ),

                ],
              ),
               SizedBox(height:screenSize.height *0.1-74),
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
              SizedBox(height: screenSize.height *0.1-60,),

              Container(
                height: screenSize.height-screenSize.height *0.2-5,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: packagesController.allPackages.length,

                    itemBuilder: (context,index)=>InkWell(
                      onTap: (){
                        buyPackageDialog(context,index);

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
                                        child: Text(  packagesController.allPackages[index]['name'],overflow:TextOverflow.ellipsis,maxLines: 1
                                          ,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // langController.appLocal=="en"?
                                              // Text("Expiry Date : ${DateFormat('yyyy-MM-dd  HH:mm :ss').format(packagesController.allPackages[index]['name'])}",style: TextStyle(color: Colors.black,),):
                                           // Text("${DateFormat('yyyy-MM-dd  HH:mm :ss').format(packages[index]['expiryDate'])}تاريخ الانتهاء: ",style: TextStyle(color: Colors.black,),),
                                              SizedBox(height: 12.0,),
                                              langController.appLocal=="en"?Text("Price : ${packagesController.allPackages[index]['price'].toStringAsFixed(3)}",style: TextStyle(color: Colors.black,),):
                                              Text("${packagesController.allPackages[index]['price'].toStringAsFixed(3)}السعر : ",style: TextStyle(color: Colors.black,),),

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
                                            TextSpan(text: "all",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),

                                          ]
                                      )),
                                       SizedBox(height: screenSize.height *0.1-75),

                                      RichText(text: TextSpan(
                                          children: [
                                          TextSpan(text: 'Unlimited Pass',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.green)),

                                          ]
                                      )),
                                    ],
                                  )
                                ],
                              ),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(onPressed:(){
                                  confirmBuyPackage(context,packagesController.allPackages[index]['id']);
                                },
                                  style: ButtonStyle(
                                    backgroundColor:MaterialStateProperty.all(Colors.white),
                                    foregroundColor: MaterialStateProperty.all(routes_color),
                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 6,horizontal: 12)),
                                  ) ,
                                  child:Text('BUY WITH WALLET'.tr,overflow:TextOverflow.ellipsis,maxLines: 1
                                    ,style: TextStyle(color: routes_color,fontSize: 14,fontWeight: FontWeight.bold),), ),

                                ElevatedButton(onPressed:(){
                                  MyFatoorahCheckOut myFatoorh = MyFatoorahCheckOut();
                                  myFatoorh.initiate(context,double.parse(packagesController.allPackages[index]['price'].toString()) , 0,true,packagesController.allPackages[index]['id'].toString());
                                },
                                  style: ButtonStyle(
                                    backgroundColor:MaterialStateProperty.all(Colors.white),
                                    foregroundColor: MaterialStateProperty.all(routes_color),
                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 6,horizontal: 12)),
                                  ) ,
                                  child:Text('BUY WITH CARD'.tr,overflow:TextOverflow.ellipsis,maxLines: 1
                                    ,style: TextStyle(color: routes_color,fontSize: 14,fontWeight: FontWeight.bold),), ),
                              ],
                            ),
                            SizedBox(height: screenSize.height *0.1-75),
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

  void buyPackageDialog(BuildContext context,int index) {
    Get.dialog(
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              height:
                  MediaQuery.of(context).size.height *0.4-20,
              width:  MediaQuery.of(context).size.width *0.9,
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
                        child: Icon(Icons.close_sharp,size: 37,color: Colors.redAccent,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(  packagesController.allPackages[index]['name'],overflow:TextOverflow.ellipsis,maxLines: 1
                      ,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 18.0,),

                  Text('Unlimited travel on all routes_txt'.tr),
                  const SizedBox(height: 118.0,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed:(){
                        confirmBuyPackage(context,packagesController.allPackages[index]['id']);
                      },
                        style: ButtonStyle(
                          backgroundColor:MaterialStateProperty.all(Colors.blue[800]),
                          foregroundColor: MaterialStateProperty.all(routes_color),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12,horizontal: 12)),
                        ) ,
                        child:Text('BUY WITH WALLET'.tr,overflow:TextOverflow.ellipsis,maxLines: 1
                          ,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),), ),

                      ElevatedButton(onPressed:(){
                        MyFatoorahCheckOut myFatoorh = MyFatoorahCheckOut();
                        myFatoorh.initiate(context,double.parse(packagesController.allPackages[index]['price'].toString()) , 0,true,packagesController.allPackages[index]['id'].toString());
                      },
                        style: ButtonStyle(
                          backgroundColor:MaterialStateProperty.all(Colors.blue[800]),
                          foregroundColor: MaterialStateProperty.all(routes_color),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12,horizontal: 12)),
                        ) ,
                        child:Text('BUY WITH CARD'.tr,overflow:TextOverflow.ellipsis,maxLines: 1
                          ,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),), ),
                    ],
                  ),



                ],
              )),
            ),
          ),
        )
    );
  }

  void confirmBuyPackage(BuildContext context,String packageId) {
    Get.dialog(Scaffold(
      backgroundColor: Colors.transparent,

      body: Center(child: Container(
          height:
          MediaQuery.of(context).size.height *0.2-50,
          width:  MediaQuery.of(context).size.width *0.6,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
          ),
        child:Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: (){
                      Get.back();

                    },
                    child: Icon(Icons.close_sharp,size: 37,color: Colors.redAccent,)),
              ),
              ElevatedButton(onPressed:()async{
                await packagesController.addPackage(id: packageId, invoiceId: '', isCard: false);

              },
                style: ButtonStyle(
                  backgroundColor:MaterialStateProperty.all(Colors.blue[800]),
                  foregroundColor: MaterialStateProperty.all(routes_color),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 6,horizontal: 12)),
                ) ,
                child:Text('Confirm'.tr,overflow:TextOverflow.ellipsis,maxLines: 1
                  ,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),), )
            ]
          ),
        )
      ),),
    ));
  }
}
