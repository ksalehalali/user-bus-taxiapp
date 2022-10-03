import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;

import '../../../Assistants/globals.dart';
import '../../../Data/current_data.dart';
import '../../../controller/lang_controller.dart';
import '../../../controller/location_controller.dart';
import '../../../controller/payment_controller.dart';
import '../../../controller/route_map_controller.dart';
import 'map.dart';

class MultiRouteDetails extends StatefulWidget {
  const MultiRouteDetails({Key? key}) : super(key: key);

  @override
  State<MultiRouteDetails> createState() => _MultiRouteDetailsState();
}
class _MultiRouteDetailsState extends State<MultiRouteDetails> {

  final String timeC = DateTime.now().hour > 11 ? 'PM' : 'AM';
  final LangController langController = Get.find();
  late double angle;
  late Matrix4 transform ;
  final routeMapController = Get.put(RouteMapController());
  final LocationController locationController = Get.find();
  final PaymentController paymentController = Get.find();

  GlobalKey _formKey3 = GlobalKey(debugLabel: 'c');
  GlobalKey _formKey4 = GlobalKey(debugLabel: 'd');
  DateTime? timeDrew = DateTime.now();
  var stops = [];
  var stopsLineEx = [];
  bool showStops = false;
  double heightLineStops = 100.0;
  late final MapController mapController;
  late final StreamSubscription<MapEvent> mapEventSubscription;
  int _eventKey = 0;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    angle = langController.appLocal == 'ar'?-180 / 180 * pi:30 / 180 * pi;
    transform = Matrix4.identity()..setEntry(3, 2,0.001 )..rotateY(angle);
    mapController = MapController();
    mapEventSubscription = mapController.mapEventStream.listen(onMapEvent);
  }
  void onMapEvent(MapEvent mapEvent) {
    if (mapEvent is MapEventMove && mapEvent.id == _eventKey.toString()) {}
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0)),
          boxShadow: [
            BoxShadow(
              color: routes_color2,
              blurRadius: 16.0,
              spreadRadius: 0.5,
              offset: Offset(0.5, 0.5),
            ),
          ]),
      child:  GestureDetector(
        onTap: (){
          if (panelController.isPanelOpen) {
            panelController.close();
          } else {
            panelController.open();
          }
        },
        onVerticalDragStart: (pos){
          if (panelController.isPanelOpen) {
            panelController.close();
          } else {
            panelController.open();
          }
        },
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 2.0,
              ),
              Container(
                width: 42.0,
                height: 4.0,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              SizedBox(
                height: 5.0,
              ),
              Column(
                children: [
                  Center(
                    child:  GestureDetector(
                      onTap: (){
                        if (panelController.isPanelOpen) {
                          panelController.close();
                        } else {
                          panelController.open();
                        }
                      },
                      onVerticalDragStart: (pos){
                        if (panelController.isPanelOpen) {
                          panelController.close();
                        } else {
                          panelController.open();
                        }
                      },
                      child: Text(
                        locationController.tripCreatedDone.value == false
                            ? "Set_your_pickup-Drop_Off_spot_txt".tr
                            : "Start_Your_Trip._txt".tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Obx(
                        () => Center(
                      child: locationController.tripCreatedDone.value == false
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(
                                () => Text(
                              locationController
                                  .startAddingPickUp.value ==
                                  true
                                  ? locationController
                                  .pickUpAddress.value
                                  : locationController
                                  .dropOffAddress.value,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      )
                          : Container(),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                ],
              ),
              Obx(
                    () => Container(
                  child: locationController.tripCreatedDone.value == true
                      ? Column(
                    children: [
                      InkWell(
                        onTap: () {
                          print(routeMapController.multiRouteTripData);
                          if (panelController.isPanelOpen) {
                            panelController.close();
                          } else {
                            panelController.open();
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform(
                                alignment:langController.appLocal == 'ar'? Alignment.center:Alignment.center,
                                transform: transform,
                                child:Icon(
                                  FontAwesomeIcons.walking,
                                  size: 21,
                                  color: Colors.grey[600],
                                )),
                            SizedBox(
                              width: 8.0,
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Icon(
                              FontAwesomeIcons.busAlt,
                              size: 21,
                              color: Colors.grey[600],
                            ),
                            SizedBox(
                              width:8.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.red[900],
                                  borderRadius:
                                  BorderRadius.circular(2)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Obx(() => Text(
                                    locationController
                                        .tripCreatedDone
                                        .value ==
                                        true
                                        ? routeMapController
                                        .multiRouteTripData[
                                    "rout1"][0]['route']
                                        .toString()
                                        : '',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold),
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Transform(
                                alignment:langController.appLocal == 'ar'? Alignment.center:Alignment.center,
                                transform: transform,
                                child:SvgPicture.asset(
                                  "assets/icons/shuffle_arrow.svg",
                                  height: 24,
                                  width: 24,
                                  color: Colors.grey[600],
                                )),
                            SizedBox(
                              width: 8.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.red[900],
                                  borderRadius:
                                  BorderRadius.circular(2)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Obx(() => Text(
                                    locationController
                                        .tripCreatedDone
                                        .value ==
                                        true
                                        ? routeMapController
                                        .multiRouteTripData[
                                    "rout2"][0]['route']
                                        .toString()
                                        : '',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold),
                                  )),
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius:
                                  BorderRadius.circular(12)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Obx(() => SizedBox(
                                    width: 141,
                                    child: Text(
                                      locationController
                                          .tripCreatedDone
                                          .value ==
                                          true
                                          ? langController.appLocal =="en"? "${routeMapController.fullDurationTrip.value.toStringAsFixed(0)} min | ${routeMapController.fullDistanceTrip.value.toStringAsFixed(0)} km ":" ${routeMapController.fullDurationTrip.value.toStringAsFixed(0)} دقيقة | ${routeMapController.fullDistanceTrip.value.toStringAsFixed(0)} كلم"
                                          : '',
                                      overflow:
                                      TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        height: 2,
                        width: screenSize.width - 30,
                        color: Colors.grey,
                      ),

                      SizedBox(
                        height: 6.0,
                      ),
                      //
                    ],
                  )
                      : Container(),
                ),
              ),
              Obx(
                    () => Container(

                  child: locationController.tripCreatedDone.value == true
                      ? Expanded(
                    key: _formKey4,
                    child: ListView(
                      key: _formKey3,
                      padding: EdgeInsets.zero,
                      children: [
                        //

                        //the problem start here
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: screenSize.width * 0.7 - 0,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Start:_txt".tr ,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(
                                            width: screenSize.width * 0.5+24,
                                            child: Text(
                                              trip.startPointAddress,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          )
                                        ],
                                      ),),
                                    SizedBox(
                                      height: screenSize.height * 0.1 - 69,
                                    ),
                                    Text(
                                      'Walk_to_bus_stop_txt'.tr,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[400]),
                                    ),
                                    SizedBox(
                                      height: screenSize.height * 0.1 - 69,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Board_at_Route_txt'.tr,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            '${routeMapController.multiRouteTripData["startStation"]['rout'].toString()}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: screenSize.width * 0.7 - 20,
                                      child: Text(
                                        '${routeMapController.multiRouteTripData["startStation"]['title'].toString()}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenSize.height * 0.1 - 62,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Change_to_txt'.tr,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child:Transform(
                                              alignment:langController.appLocal == 'ar'? Alignment.center:Alignment.center,
                                              transform: transform,
                                              child: SvgPicture.asset(
                                                "assets/icons/shuffle_arrow.svg",
                                                height: 16,
                                                width: 16,
                                                color: Colors.grey[600],
                                              )),
                                        ),
                                        Text(
                                          '${routeMapController.route2[0]['route'].toString()} ',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      width: screenSize.width * 0.7 - 20,
                                      child: Text(
                                        '${routeMapController.multiRouteTripData["sharedPoint1"]['title'].toString()}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenSize.height * 0.1 - 62,
                                    ),
                                    // Padding(
                                    //   padding:  EdgeInsets.only(top: screenSize.height * 0.1 - 72,bottom:screenSize.height * 0.1 - 72,),
                                    //   child: InkWell(
                                    //     onTap: (){
                                    //       print(stops);
                                    //       if(stops.length ==0){
                                    //         _buildStopsOfTrip();
                                    //         showStops = true;
                                    //       }else{
                                    //         showStops =false;
                                    //         setState(() {
                                    //           stops = [];
                                    //           heightLineStops = 100;
                                    //           stopsLineEx = [];
                                    //         });
                                    //       }
                                    //     },
                                    //     child: Row(
                                    //       crossAxisAlignment:
                                    //       CrossAxisAlignment
                                    //           .center,
                                    //       children: [
                                    //         Text(
                                    //           'Stops (${routeMapController.jsonResponse.length})',
                                    //           style: TextStyle(
                                    //               fontWeight:
                                    //               FontWeight
                                    //                   .w500,
                                    //               color: Colors
                                    //                   .grey[500]),
                                    //         ),
                                    //         Icon(
                                    //           showStops ==false ?Icons.keyboard_arrow_down_sharp:Icons.keyboard_arrow_up,
                                    //           size: 17,
                                    //           color:
                                    //           Colors.grey[500],
                                    //         )
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: screenSize.height * 0.1 - 82,
                                    // ),
                                    // ...stops,
                                    Text(
                                      'Get_off_at_txt'.tr,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: screenSize.width * 0.7 - 20,
                                      child: Text(
                                        '${routeMapController.endStation['title'].toString()}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenSize.height * 0.1 - 64,
                                    ),
                                    SizedBox(
                                        width: screenSize.width * 0.7 - 20,
                                        child: Text(
                                          Get.locale =="ar" ?'النهاية : ${trip.endPointAddress}' :'End : ${trip.endPointAddress}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                              BorderRadius.circular(1)),
                                          width: 13,
                                          height: 13,
                                        ),
                                        SizedBox(
                                          height:
                                          screenSize.height * 0.1 - 76,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                              BorderRadius.circular(1)),
                                          width: 7,
                                          height: 7,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                                borderRadius:
                                                BorderRadius.circular(
                                                    1)),
                                            width: 7,
                                            height: 7),
                                        SizedBox(
                                          height: 9.0,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.walking,
                                          color: Colors.grey[700],
                                          size: 22,
                                        ),
                                        SizedBox(
                                          height: 9.0,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                              BorderRadius.circular(1)),
                                          width: 7,
                                          height: 7,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                              BorderRadius.circular(1)),
                                          width: 7,
                                          height: 7,
                                        ),
                                        SizedBox(
                                            height:
                                            screenSize.height * 0.1 -
                                                76),
                                        AnimatedContainer(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[700],
                                            borderRadius:
                                            BorderRadius.circular(1),
                                          ),
                                          height: heightLineStops,
                                          width: 5,
                                          duration: 200.milliseconds,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              ...stopsLineEx,
                                              SizedBox(
                                                  height:
                                                  screenSize.height *
                                                      0.1 -
                                                      76),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(1)),
                                                width: 9,
                                                height: 9,
                                              ),
                                              Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(1)),
                                                width: 9,
                                                height: 9,
                                              ),
                                              SizedBox(
                                                  height:
                                                  screenSize.height *
                                                      0.1 -
                                                      76),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                            screenSize.height * 0.1 -
                                                73),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                              BorderRadius.circular(1)),
                                          width: 7,
                                          height: 7,
                                        ),
                                        SizedBox(
                                            height:
                                            screenSize.height * 0.1 -
                                                78),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                              BorderRadius.circular(1)),
                                          width: 7,
                                          height: 7,
                                        ),
                                        SizedBox(
                                            height:
                                            screenSize.height * 0.1 -
                                                76),
                                        InkWell(
                                          onTap: () {
                                            print('object');
                                            setState(() {
                                              heightLineStops = 200;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.red[900],
                                                borderRadius:
                                                BorderRadius.circular(
                                                    1)),
                                            width: 13,
                                            height: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print(
                                            'st w d ${routeMapController.startWalkDurationTrip}');
                                        print(
                                            'route t d ${routeMapController.routeDurationTrip}');
                                        print(
                                            'sec route t d ${routeMapController.secondRouteDurationTrip}');
                                        print(
                                            'sec walk  d ${routeMapController.secondWalkDurationTrip}');
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                              '${DateFormat('HH:mm').format(timeDrew!).toString()} $timeC'),
                                          SizedBox(
                                              height:
                                              screenSize.height * 0.1),
                                          Text(
                                              '${DateFormat('HH:mm').format(timeDrew!.add(routeMapController.startWalkDurationTrip.value.minutes)).toString()} $timeC'),
                                          SizedBox(
                                              height: heightLineStops - 18),
                                          Text(
                                              '${DateFormat('HH:mm').format(timeDrew!.add(routeMapController.routeDurationTrip.value.minutes + routeMapController.startWalkDurationTrip.value.minutes + routeMapController.secondRouteDurationTrip.value.minutes)).toString()} $timeC'),
                                          SizedBox(
                                              height:
                                              screenSize.height * 0.1 -
                                                  60),
                                          Text(
                                              '${DateFormat('HH:mm').format(timeDrew!.add(routeMapController.secondRouteDurationTrip.value.minutes + routeMapController.routeDurationTrip.value.minutes + routeMapController.startWalkDurationTrip.value.minutes + routeMapController.secondWalkDurationTrip.value.minutes)).toString()} $timeC'),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),

                          ],
                        ),
                        //

                      ],
                    ),
                  )
                      : Container(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
