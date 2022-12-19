import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/lang_controller.dart';
import '../../../controller/trip_controller.dart';

class FavoriteAddressesScreen extends StatefulWidget {
  const FavoriteAddressesScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteAddressesScreen> createState() => _FavoriteAddressesScreenState();
}

class _FavoriteAddressesScreenState extends State<FavoriteAddressesScreen> {
  final TripController trips = Get.find();
  final LangController langController = Get.find();

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
                    child: Obx(()=> Text('${trips.total.value}',style: TextStyle(color: Colors.blue[900],fontSize: 16,fontWeight: FontWeight.bold),)),
                  ),
                ],
              ),
            ),
            Container(
              height: screenSize.height- 140,
              width: screenSize.width,
              child: FutureBuilder(
                future: trips.getMyTrips(),
                builder: (context,data)=> Obx(()=> ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: trips.trips.length,
                    itemBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 2,
                            width: screenSize.width ,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],

                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10.0,),
                                    RichText(text: TextSpan(
                                        children: [
                                          TextSpan(text: 'name_txt'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black)),
                                          TextSpan(text: trips.trips[index]['rout'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),

                                        ]
                                    )),

                                    SizedBox(height: 5.0,),
                                    RichText(text: TextSpan(
                                        children: [
                                          TextSpan(text: 'Address_txt'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black)),
                                          TextSpan(text: trips.trips[index]['rout'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),

                                        ]
                                    ))
                                  ],
                                ),
                                Spacer(),
                                //Text('Route : ${trips.trips[index]['rout']}'),
                                SizedBox(
                                  width: 220.0,
                                  child: Text(  trips.trips[index]['date'],overflow:TextOverflow.ellipsis,maxLines: 1
                                    ,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
