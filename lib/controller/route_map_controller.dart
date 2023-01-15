import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:routes/controller/trip_controller.dart';
import 'package:signalr_core/signalr_core.dart';
import '../Assistants/globals.dart';
import '../Data/current_data.dart';
import '../config-maps.dart';
import '../view/screens/map/map.dart';
import 'location_controller.dart';

class RouteMapController extends GetxController {
  var clickedPoint = new LatLng(0, 0).obs; //Location(0, 0).obs;
  var routePoints = <LatLng>[new LatLng(0, 0), new LatLng(0, 0)].obs;
  var startPointLatLng = new LatLng(0.0, 0.0).obs;
  var endPointLatLng = new LatLng(0.0, 0.0).obs;
  var startStation = {};
  var sharedStation = {};
  var sharedStation2 = {};

  var endStation = {};
  var tripFirstWalkDirData = {}.obs;
  var tripSecondWalkDirData = {}.obs;

  var tripStationDirData = {}.obs;
  var tripStationDirData2 = {}.obs;

  var multiRouteTripData = {}.obs;
  var multiTripStationDirData2Route2 = {}.obs;
  var multiTripStationDirDataRoute2 = {}.obs;
  var multiTripStationDirData2Route1 = {}.obs;
  var multiTripStationDirDataRoute1 = {}.obs;

  var tripRouteData = {}.obs;

  var fullDurationTrip = 0.0.obs;
  var startWalkDurationTrip = 0.0.obs;

  var secondWalkDurationTrip = 0.0.obs;

  var secondRouteDurationTrip = 0.0.obs;
  var secondRoute2DurationTrip = 0.0.obs;

  var routeDurationTrip = 0.0.obs;
  var route2DurationTrip = 0.0.obs;


  var fullDistanceTrip = 0.0.obs;
  var startWalkDistanceTrip = 0.0.obs;
  var secondRouteDistanceTrip = 0.0.obs;
  var secondRoute2DistanceTrip = 0.0.obs;

  var secondWalkDistanceTrip = 0.0.obs;
  var routeDistanceTrip = 0.0.obs;
  var route2DistanceTrip = 0.0.obs;




  var centerOfDirRoute =  google_maps.LatLng(0.0, 0.0).obs;
  var index = 0.obs;
  int indexOfStations = 0;
  int intIndex = 0;
  var isMultiMode = false.obs;
  var firstTurn = true.obs;
  var isLongTrip = false.obs;

  var stationLocationPoints = <LatLng>[].obs;
  var stationLocationPoints2 = <LatLng>[].obs;

  var tripFirstWalkWayPointsG = <google_maps.LatLng>[].obs;
  var tripSecondWalkWayPointsG = <google_maps.LatLng>[].obs;

  var tripStationWayPointsG = <google_maps.LatLng>[].obs;
  var tripStationWayPoints2G = <google_maps.LatLng>[].obs;

  var tripStationWayPointsRoute2 = <google_maps.LatLng>[].obs;
  var tripStationWayPointsRoute1 = <google_maps.LatLng>[].obs;

  var route1 =[].obs;
  var route2 = [].obs;
  var jsonResponse;

  var latPinLoc = trip.startPoint.latitude.obs;
  var lngPinLoc = trip.startPoint.longitude.obs;

  var stationMarkers = <Marker>[].obs;

  // handle reset
  var  resetNo = 0.obs;

  void resetAll() {
    resetNo.value++;
    fullDistanceTrip.value=0.0;
    fullDurationTrip.value = 0.0;
    stationMarkers.value = [];
    tripFirstWalkWayPointsG.value = [];
    routePoints.value =[];
    tripSecondWalkWayPointsG.value = [];

    stationLocationPoints.value = [];
    tripStationWayPointsG.value = [];
    stationLocationPoints2.value = [];
    tripStationWayPointsRoute2.value = [];
    tripStationWayPointsRoute1.value = [];
    route1.value =[];
    route2.value =[];

    stationMarkers.value = [];
    tripRouteData.value = {};
    tripStationDirData2.value = {};
    tripStationWayPoints2G.value = [];

    fullDistanceTrip.value = 0.0;
    fullDurationTrip.value = 0.0;
    route2DurationTrip.value =0.0;
    route2DistanceTrip.value = 0.0;
    routeDistanceTrip.value =0.0;
    routeDurationTrip.value =0.0;
    secondRoute2DistanceTrip.value =0.0;
    secondRoute2DurationTrip.value = 0.0;
    secondRouteDurationTrip.value =0.0;
    secondRouteDistanceTrip.value =0.0;
    secondWalkDistanceTrip.value = 0.0;
    secondWalkDurationTrip.value =0.0;
    startWalkDistanceTrip.value = 0.0;
    startWalkDurationTrip.value =0.0;

    // trip.startPoint.latitude = 0.0;
    // trip.startPoint.longitude = 0.0;
    trip.endPoint.latitude = 0.0;
    trip.endPoint.longitude = 0.0;
    // trip.startPointAddress = '';
     trip.endPointAddress = '';
    // startStation = {};
    // endStation= {};
    // sharedStation= {};
    isMultiMode.value =false;


    update();
  }

  final LocationController locationController = Get.find();
  final TripController tripController = Get.find();

  Future<void> findFirstWalkDirection(
      LatLng startPoint, LatLng endPoint) async {
    tripFirstWalkDirData.value ={};
    final response = await http.get(Uri.parse(
        "https://api.mapbox.com/directions/v5/mapbox/walking/${startPoint.longitude},${startPoint.latitude};${endPoint.longitude},${endPoint.latitude}?alternatives=true&annotations=distance%2Cduration%2Cspeed%2Ccongestion&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$mapbox_token"));

    if (response.statusCode == 200) {
      print('true start walking polyline  ${response.body}');
      var decoded = jsonDecode(response.body);
      tripFirstWalkDirData.value = decoded;

      startWalkDurationTrip.value = decoded['routes'][0]['duration'] /60;
      startWalkDistanceTrip.value =decoded['routes'][0]['distance']/1000;

      print('first walk details, time:: ${decoded['routes'][0]['duration']}--  ${decoded['routes'][0]['distance']}');
      decoded = decoded["routes"][0]["geometry"];

      for (int i = 0; i < decoded["coordinates"].length; i++) {
        tripFirstWalkWayPointsG.add(google_maps.LatLng(
            decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
      }
    } else {
      print('11111NNNOOOOOONnonooooOOO ${response.statusCode}');
    }
  }

  Future<void> findSecondWalkDirection(
      LatLng startPoint, LatLng endPoint) async {
    tripSecondWalkDirData.value ={};
    final response = await http.get(Uri.parse(
        "https://api.mapbox.com/directions/v5/mapbox/walking/${startPoint.longitude},${startPoint.latitude};${endPoint.longitude},${endPoint.latitude}?alternatives=true&annotations=distance%2Cduration%2Cspeed%2Ccongestion&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$mapbox_token"));
    print('staaaart$startPoint');
    if (response.statusCode == 200) {
      print('trueeee sec walk polyline ${response.body}');
      var decoded = jsonDecode(response.body);
      tripSecondWalkDirData.value = decoded;
      secondWalkDurationTrip.value = decoded['routes'][0]['duration'] /60;
      secondWalkDistanceTrip.value =decoded['routes'][0]['distance']/1000;
      print('second walk details, time:: ${decoded['routes'][0]['duration']}--  ${decoded['routes'][0]['distance']}');

      decoded = decoded["routes"][0]["geometry"];
      for (int i = 0; i < decoded["coordinates"].length; i++) {

        tripSecondWalkWayPointsG.add(google_maps.LatLng(
            decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
      }

      //handle if index of routeStations lees than 2
      if (index.value < 2) {
        locationController.tripCreatedStatus(false);
        resetAll();
        Get.snackbar('Invalid Data', 'Please inter right points for your trip',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3));
        Timer(Duration(seconds: 1), () {
        });
        return;
      }
    } else {
      print('2222NNNOOOOOONnonooooOOO ${response.body}');
    }
  }

  Future<void> findStationDirection(String stationQuery,int groupNum) async {
    print('--------------------------');
    print(centerOfDirRoute.value);

      final response = await http.get(Uri.parse(
          "https://api.mapbox.com/directions/v5/mapbox/driving/$stationQuery?alternatives=true&annotations=distance%2Cduration%2Cspeed%2Ccongestion&geometries=geojson&language=en&overview=full&access_token=$mapbox_token"));
      if (response.statusCode == 200) {
        print('dir ====-------------------------------------------------------------------====');
        print('true 1 ${response.statusCode}');
        var decoded = jsonDecode(response.body);
        print('dir === $decoded');

        if(groupNum ==1){
          tripStationDirData.value = decoded;

        }else {
          tripStationDirData2.value = decoded;
        }
        routeDurationTrip.value =decoded['routes'][0]['duration']/ 60;
        routeDistanceTrip.value = decoded['routes'][0]['distance']/1000;

        decoded = decoded["routes"][0]["geometry"];
        for (int i = 0; i < decoded["coordinates"].length; i++) {
          tripStationWayPointsG.add(google_maps.LatLng(
              decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
        }
        locationController.tripCreatedStatus(true);

        //moving camera
        google_maps.CameraPosition cameraPosition =
         google_maps.CameraPosition(target: centerOfDirRoute.value, zoom: 13.6);
        newGoogleMapController!.animateCamera(
            google_maps.CameraUpdate.newCameraPosition(cameraPosition));

      } else {
        print('error :: ${response.body}');
        print('stationNNNOOOOO 11 ${response.statusCode} \n${stationQuery}');
        locationController.tripCreatedStatus(false);
        return;
      }

  }

  //find directions for multi
  Future<void> findStationDirectionMulti(String stationQuery, bool isSecond,bool isRoute2) async {
    print('--------------------------');
    print(centerOfDirRoute.value);

    if (isSecond == false) {
      final response = await http.get(Uri.parse(
          "https://api.mapbox.com/directions/v5/mapbox/driving-traffic/$stationQuery?alternatives=true&annotations=distance%2Cduration%2Cspeed%2Ccongestion&geometries=geojson&language=en&overview=full&access_token=$mapbox_token"));
      if (response.statusCode == 200) {
        print('true 1 ${response.statusCode}');
        var decoded = jsonDecode(response.body);

        if(isRoute2 ==true){
          print('false ..true${decoded}');
          multiTripStationDirDataRoute2.value = decoded;
          secondRouteDurationTrip.value = secondRouteDurationTrip.value +  decoded['routes'][0]['duration'] /60;
          secondRouteDistanceTrip.value = secondRouteDistanceTrip.value + decoded['routes'][0]['distance']/1000;

          print('duration second route 2 == ${decoded['routes'][0]['duration'] /60 }');

          decoded = decoded["routes"][0]["geometry"];
          for (int i = 0; i < decoded["coordinates"].length; i++) {
            tripStationWayPointsRoute2.add(google_maps.LatLng(
                decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
          }
          update();
        }else{
          multiTripStationDirData2Route2.value = decoded;
          routeDurationTrip.value = routeDurationTrip.value +  decoded['routes'][0]['duration'] /60;
          routeDistanceTrip.value = routeDistanceTrip.value + decoded['routes'][0]['distance']/1000;
          print('duration  route 1 = ${decoded['routes'][0]['duration'] /60 }');

          decoded = decoded["routes"][0]["geometry"];

          for (int i = 0; i < decoded["coordinates"].length; i++) {
            tripStationWayPointsRoute1.add(google_maps.LatLng(
                decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
          }
        }

        //moving camera
        google_maps.CameraPosition cameraPosition =
        google_maps.CameraPosition(target: centerOfDirRoute.value, zoom: 13.6);
        newGoogleMapController!.animateCamera(
            google_maps.CameraUpdate.newCameraPosition(cameraPosition));

      } else {
        print('error :: ${response.body}');
        print('stationNNNOOOOO 11 ${response.statusCode} \n${stationQuery}');
        locationController.tripCreatedStatus(false);
        return;
      }
    } else {
      final response = await http.get(Uri.parse(
          "https://api.mapbox.com/directions/v5/mapbox/driving/$stationQuery?alternatives=true&annotations=distance%2Cduration%2Cspeed%2Ccongestion&geometries=geojson&language=en&overview=full&access_token=$mapbox_token"));
      //print('full res from find == ${response.body}');
      if (response.statusCode == 200) {

        print('true 2 ${response.statusCode}');
        var decoded = jsonDecode(response.body);
        if(isRoute2 ==false){
          multiTripStationDirData2Route1.value = decoded;
          route2DurationTrip.value = route2DurationTrip.value +  decoded['routes'][0]['duration'] /60;
          route2DistanceTrip.value = route2DistanceTrip.value + decoded['routes'][0]['distance']/1000;

          decoded = decoded["routes"][0]["geometry"];
          for (int i = 0; i < decoded["coordinates"].length; i++) {

            tripStationWayPointsRoute1.add(google_maps.LatLng(
                decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
          }
        }else{
          multiTripStationDirData2Route2.value = decoded;
          secondRoute2DurationTrip.value = secondRoute2DurationTrip.value +  decoded['routes'][0]['duration'] /60;
          secondRoute2DistanceTrip.value = secondRoute2DistanceTrip.value + decoded['routes'][0]['distance']/1000;
          decoded = decoded["routes"][0]["geometry"];
          for (int i = 0; i < decoded["coordinates"].length; i++) {
            tripStationWayPointsRoute2.add(google_maps.LatLng(
                decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
          }
          update();
        }

        locationController.tripCreatedStatus(true);
        //moving camera
        google_maps.CameraPosition cameraPosition =
        google_maps.CameraPosition(target: centerOfDirRoute.value, zoom: 13.6);
        newGoogleMapController!.animateCamera(
            google_maps.CameraUpdate.newCameraPosition(cameraPosition));
      } else {
        print('stationNNNOOOOO 2 ${response.statusCode} \n${stationQuery}');
        print(response.body);
      }
    }
  }

  Future<void> findStationLocations() async {

    final queryParameters = {
      "Longitude1": startPointLatLng.value.longitude,
      "Latitude1": startPointLatLng.value.latitude,
      "Longitude2": endPointLatLng.value.longitude,
      "Latitude2": endPointLatLng.value.latitude
    };

    print("trip lat lng::: $queryParameters " );
    print(queryParameters);
    final url = Uri.parse(baseURL + "/api/FindRoute");
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${user.accessToken}",
    };

    final response =
        await post(url, headers: headers, body: jsonEncode(queryParameters));

    print(response.statusCode);

     jsonResponse = jsonDecode(response.body);

    /// go to handle multi routes
    if (jsonResponse["status"] == false) {
      // Get.snackbar(
      //     'there is no route', 'wrong points entered',
      //     backgroundColor: Colors.white.withOpacity(0.9),
      //     duration: 5.seconds, colorText: Colors.red[900]);
      findMultiRoute();
    }else if(jsonResponse['description']['res'].length <2){
      print('bad data ----');
      resetAll();
      Get.snackbar(
          'there is no route', 'wrong points entered',
          backgroundColor: Colors.white.withOpacity(0.9),
          duration: 5.seconds, colorText: Colors.red[900]);
      return;
    }else{

      trip.routeId =jsonResponse["description"]["res"][0]["routeID"];
      trip.routeName = "Route ${jsonResponse["description"]["res"][0]["route"]}";
        isMultiMode.value =false ;
        String stationQuery = "";
        String stationQuery2 = "";
        String stationQuery3 = "";
        String stationQuery4 = "";
        print("find route res --=== ::$jsonResponse");
        print("find route ID --=== ::${jsonResponse["description"]["res"][0]["routeID"]}");

        stationMarkers.value = [];
        tripRouteData.value = jsonResponse;

        startStation = jsonResponse["description"]['startStation'];
        endStation = jsonResponse["description"]['endStation'];

        jsonResponse = jsonResponse["description"]["res"];
        print('points count :: ${jsonResponse.length}');

        // dir 2
        if (jsonResponse.length > 74) {
          centerOfDirRoute.value= google_maps.LatLng(jsonResponse[3]["latitude"],jsonResponse[3]["longitude"]);

          isLongTrip.value = true;
          print('get long route -----------');
          for (int i = 0; i < 24; i++) {
            print(jsonResponse[i]);
            stationQuery = stationQuery +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
            index.value = i;
          }

          for (int i = 24; i < 49; i++) {
            print(jsonResponse[i]);
            stationQuery2 = stationQuery2 +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints2.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
          }

          /// for more points
          for (int i = 49; i < 74; i++) {
            print(jsonResponse[i]);
            stationQuery3 = stationQuery3 +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints2.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
          }

          for (int i = 74; i < jsonResponse.length; i++) {
            print(jsonResponse[i]);
            stationQuery4 = stationQuery4 +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints2.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
          }
          stationQuery = stationQuery.substring(
              0, stationQuery.length - 1); // To remove the last semicolon from the string (would cause an error)
          await findStationDirection(stationQuery,1);
          stationQuery2 = stationQuery2.substring(
              0, stationQuery2.length - 1); // To remove the last semicolon from the string (would cause an error)
          await findStationDirection(stationQuery2, 2);
          stationQuery3 = stationQuery3.substring(
              0, stationQuery3.length - 1); // To remove the last semicolon from the string (would cause an error)
          await findStationDirection(stationQuery3, 3);
          stationQuery4 = stationQuery4.substring(
              0, stationQuery4.length - 1); // To remove the last semicolon from the string (would cause an error)
          await findStationDirection(stationQuery4,4 );
          //
          update();
          await findFirstWalkDirection(
              LatLng(startPointLatLng.value.latitude,
                  startPointLatLng.value.longitude),
              LatLng(startStation['latitude'], startStation['longitude']));

          await findSecondWalkDirection(
              LatLng(endStation['latitude'], endStation['longitude']),
              LatLng(
                  endPointLatLng.value.latitude, endPointLatLng.value.longitude));
          locationController.tripCreatedStatus(true);
          await locationController.getRouteBusses(jsonResponse[0]["routeID"]);

          calculateFullDurationDistance(false,false);
          return;

        } else if(jsonResponse.length <= 74 && jsonResponse.length > 50 ) {
          centerOfDirRoute.value= google_maps.LatLng(jsonResponse[3]["latitude"],jsonResponse[3]["longitude"]);

          isLongTrip.value = false;
          for (int i = 0; i < 24; i++) {
            print(jsonResponse[i]);
            stationQuery = stationQuery +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
            index.value = i;
          }
          for (int i = 24; i < 49; i++) {
            print(jsonResponse[i]);
            stationQuery2 = stationQuery2 +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints2.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
          }

          /// for more points
          for (int i = 49; i < jsonResponse.length; i++) {
            print(jsonResponse[i]);
            stationQuery3 = stationQuery3 +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints2.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
          }
          stationQuery = stationQuery.substring(
              0, stationQuery.length - 1); // To remove the last semicolon from the string (would cause an error)
          await findStationDirection(stationQuery,1 );
          stationQuery2 = stationQuery2.substring(
              0, stationQuery2.length - 1); // To remove the last semicolon from the string (would cause an error)
          await findStationDirection(stationQuery2,2 );
          stationQuery3 = stationQuery3.substring(
              0, stationQuery3.length - 1); // To remove the last semicolon from the string (would cause an error)
          await findStationDirection(stationQuery3,3 );
          //
          update();
          await findFirstWalkDirection(
              LatLng(startPointLatLng.value.latitude,
                  startPointLatLng.value.longitude),
              LatLng(startStation['latitude'], startStation['longitude']));

          await findSecondWalkDirection(
              LatLng(endStation['latitude'], endStation['longitude']),
              LatLng(
                  endPointLatLng.value.latitude, endPointLatLng.value.longitude));
          locationController.tripCreatedStatus(true);
          await locationController.getRouteBusses(jsonResponse[0]["routeID"]);

          calculateFullDurationDistance(false,false);
          return;


        }else if(jsonResponse.length <= 50 && jsonResponse.length > 25){
          centerOfDirRoute.value= google_maps.LatLng(jsonResponse[3]["latitude"],jsonResponse[3]["longitude"]);

          print('length <= 50 > 25');
          isLongTrip.value = false;
          for (int i = 0; i <= 24; i++) {
            print(jsonResponse[i]);
            stationQuery = stationQuery +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
            index.value = i;
          }
          for (int i = 24; i < jsonResponse.length; i++) {
            print(jsonResponse[i]);
            stationQuery2 = stationQuery2 +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints2.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
          }
          stationQuery = stationQuery.substring(
              0, stationQuery.length - 1); // To remove the last semicolon from the string (would cause an error)
          await findStationDirection(stationQuery,1 );

          stationQuery2 = stationQuery2.substring(
              0, stationQuery2.length - 1); // To remove the last semicolon from the string (would cause an error)
          await findStationDirection(stationQuery2,2 );

          update();
          await findFirstWalkDirection(
              LatLng(startPointLatLng.value.latitude,
                  startPointLatLng.value.longitude),
              LatLng(startStation['latitude'], startStation['longitude']));

          await findSecondWalkDirection(
              LatLng(endStation['latitude'], endStation['longitude']),
              LatLng(
                  endPointLatLng.value.latitude, endPointLatLng.value.longitude));
          locationController.tripCreatedStatus(true);
          await locationController.getRouteBusses(jsonResponse[0]["routeID"]);

          calculateFullDurationDistance(false,false);
          return;

        }else{
          centerOfDirRoute.value= google_maps.LatLng(jsonResponse[2]["latitude"],jsonResponse[2]["longitude"]);

          for (int i = 0; i < jsonResponse.length; i++) {
            print(jsonResponse[i]);
            stationQuery = stationQuery +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
            index.value = i;
          }
          stationQuery = stationQuery.substring(
              0, stationQuery.length - 1); // To remove the last semicolon from the string (would cause an error)
          await findStationDirection(stationQuery, 1);

          //
          update();
          await findFirstWalkDirection(
              LatLng(startPointLatLng.value.latitude,
                  startPointLatLng.value.longitude),
              LatLng(startStation['latitude'], startStation['longitude']));

          await findSecondWalkDirection(
              LatLng(endStation['latitude'], endStation['longitude']),
              LatLng(
                  endPointLatLng.value.latitude, endPointLatLng.value.longitude));
          locationController.tripCreatedStatus(true);
          await locationController.getRouteBusses(jsonResponse[0]["routeID"]);

          calculateFullDurationDistance(false,false);
          return;

        }


    }

  }

  //go multi
  findMultiRoute()async{
    final queryParameters = {
      "Longitude1": startPointLatLng.value.longitude,
      "Latitude1": startPointLatLng.value.latitude,
      "Longitude2": endPointLatLng.value.longitude,
      "Latitude2": endPointLatLng.value.latitude
    };
    print('multi route running .......');
    Get.snackbar(
        'go to multi routes', 'we trying to get multi routes for you',
        duration: 3.seconds, colorText: Colors.blue[900]);
    isMultiMode.value = true;
    final url = Uri.parse(baseURL + "/api/FindMultiRoute");
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${user.accessToken}",
    };

    final response =
    await post(url, headers: headers, body: jsonEncode(queryParameters));

    print(response.statusCode);
    // print(" multi routes .... :: ${response.body}");
    var jsonResponse = jsonDecode(response.body);

    jsonResponse = jsonDecode(response.body);
    if (jsonResponse["status"] == false) {
      print('there is no route !! .......');
      Timer(3.seconds, () {
        Get.snackbar(
            'there is no route', 'no route please try change your points',
            backgroundColor: Colors.white,
            duration: 5.seconds, colorText: Colors.red[900]);
      });
      isMultiMode.value = false;
      return;
    }else if(jsonResponse["status"] == true){
      multiRouteTripData.value = jsonResponse;
      isMultiMode.value =true;
      print('findeMultiRoute1 res :: $jsonResponse');

      startStation = jsonResponse['startStation'];
      sharedStation = jsonResponse['sharedPoint1'];
      sharedStation2 = jsonResponse['sharedPoint2'];
      endStation = jsonResponse['endStation'];

      if(jsonResponse["description"]=="NO Point"){
        isMultiMode.value = false;

        Timer(1000.milliseconds, () {
        Get.snackbar(
            'there is no route', 'no route please try change your points',
            backgroundColor: Colors.white,
            duration: 5.seconds, colorText: Colors.red[900]);
      });
      return;
      }


      print('route1 = ${jsonResponse['rout1'][0]['route']} ---- route 2 = ${jsonResponse['rout2'][0]['route']}');
      print('route1 = ${jsonResponse['rout1']} --- ');

      trip.routeId =jsonResponse['rout1'][0]['routeID'];
       route1.value = jsonResponse['rout1'];
       route2.value = jsonResponse['rout2'];

       // centerOfDirRoute
      index.value = route1.length;
      // var i = index.value / 2;
      // intIndex = index.value;
      // int b = i.round();
      // centerOfDirRoute.value =
      //     google_maps.LatLng(route1[b]["latitude"], route1[b]["longitude"]);

      print('route 2 = ${jsonResponse['rout2']} ====================');

      print('route1 = ${jsonResponse['rout1'][0]['route']} ---- route 2 = ${jsonResponse['rout2'][0]['route']}');

      //print("center :: $b");
      print("length :::1 ${route1.length}");
      print("length :::2 ${route2.length}");

      var stationQuery = "";
      var stationQuery1 = "";
      var stationQuery2 = "";
      var stationQuery3 = "";
      var stationQuery4 = "";
      var stationQuery5 = "";
      var stationQuery6 = "";

      //route 1

      if(route1.length >50){
        isLongTrip.value =true;
        for (int i = 0; i  <= 24; i++) {
          print(route1[i]['station']);
          print(route1[i]['order']);
          print(route1[i]['route']);

          stationQuery = stationQuery +
              route1[i]["longitude"].toString() +
              "," +
              route1[i]["latitude"].toString() +
              ";";

        }
        for (int i = 24; i  < 49; i++) {
          print(route1[i]['station']);
          print(route1[i]['order']);
          print(route1[i]['route']);

          stationQuery1 = stationQuery1 +
              route1[i]["longitude"].toString() +
              "," +
              route1[i]["latitude"].toString() +
              ";";

        }
        for (int i = 49; i  < route1.length; i++) {
          print(route1[i]['station']);
          print(route1[i]['order']);
          print(route1[i]['route']);

          stationQuery2 = stationQuery2 +
              route1[i]["longitude"].toString() +
              "," +
              route1[i]["latitude"].toString() +
              ";";
        }

        await findFirstWalkDirection(
            LatLng(startPointLatLng.value.latitude,
                startPointLatLng.value.longitude),
            LatLng(startStation['latitude'], startStation['longitude']));
        stationQuery = stationQuery.substring(0,
            stationQuery.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery, false,false);

        stationQuery1 = stationQuery1.substring(0,
            stationQuery1.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery1, true,false);

        stationQuery2 = stationQuery2.substring(0,
            stationQuery2.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery2, true,false);

        await findSecondWalkDirection(LatLng(endStation['latitude'], endStation['longitude']),LatLng(endPointLatLng.value.latitude,endPointLatLng.value.longitude) ).then((value) => calculateFullDurationDistanceMulti(true,false));
        //get correct bus
        await locationController.getRouteBusses(jsonResponse['rout1'][0]['routeID']);
        panelController.open();

      }else if(route1.length <= 50 && route1.length >25){
        isLongTrip.value =true;
        for (int i = 0; i  < 24; i++) {
          print(route1[i]['station']);
          print(route1[i]['order']);
          print(route1[i]['route']);

          stationQuery = stationQuery +
              route1[i]["longitude"].toString() +
              "," +
              route1[i]["latitude"].toString() +
              ";";

        }
        for (int i = 24; i  < route1.length; i++) {
          print(route1[i]['station']);
          print(route1[i]['order']);
          print(route1[i]['route']);

          stationQuery1 = stationQuery1 +
              route1[i]["longitude"].toString() +
              "," +
              route1[i]["latitude"].toString() +
              ";";

        }

        await findFirstWalkDirection(
            LatLng(startPointLatLng.value.latitude,
                startPointLatLng.value.longitude),
            LatLng(startStation['latitude'], startStation['longitude']));

        stationQuery = stationQuery.substring(0,
            stationQuery.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery, false,false);

        stationQuery1 = stationQuery1.substring(0,
            stationQuery1.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery1, true,false);

        await findSecondWalkDirection(LatLng(endStation['latitude'], endStation['longitude']),LatLng(endPointLatLng.value.latitude,endPointLatLng.value.longitude)  );
        calculateFullDurationDistanceMulti(true,false);
        //get correct bus
        await locationController.getRouteBusses(jsonResponse['rout1'][0]['routeID']);
        panelController.open();


      }else{

        for (int i = 0; i  < route1.length; i++) {
          print(route1[i]['station']);
          print(route1[i]['order']);
          print(route1[i]['route']);

          stationQuery = stationQuery +
              route1[i]["longitude"].toString() +
              "," +
              route1[i]["latitude"].toString() +
              ";";

        }
        await findFirstWalkDirection(
            LatLng(startPointLatLng.value.latitude,
                startPointLatLng.value.longitude),
            LatLng(startStation['latitude'], startStation['longitude']));
        stationQuery = stationQuery.substring(0,
            stationQuery.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery, false,false);
        await findSecondWalkDirection(LatLng(endStation['latitude'], endStation['longitude']),LatLng(endPointLatLng.value.latitude,endPointLatLng.value.longitude) ).then((value) => Timer(2.seconds, ()=>calculateFullDurationDistanceMulti(false,false)));
        //get correct bus
        await locationController.getRouteBusses(jsonResponse['rout1'][0]['routeID']);
        panelController.open();

      }

      //route 2
      if(route2.length > 74){
        for (int i = 0; i  < 24; i++) {
          print(route2[i]['station']);
          print(route2[i]['order']);
          print(route2[i]['route']);

          stationQuery3 = stationQuery3 +
              route2[i]["longitude"].toString() +
              "," +
              route2[i]["latitude"].toString() +
              ";";

        }
        for (int i = 24; i  < 49; i++) {
          print(route2[i]['station']);
          print(route2[i]['order']);
          print(route2[i]['route']);

          stationQuery4 = stationQuery4 +
              route2[i]["longitude"].toString() +
              "," +
              route2[i]["latitude"].toString() +
              ";";

        }
        for (int i = 49; i  < 74; i++) {
          print(route2[i]['station']);
          print(route2[i]['order']);
          print(route2[i]['route']);

          stationQuery5 = stationQuery5 +
              route2[i]["longitude"].toString() +
              "," +
              route2[i]["latitude"].toString() +
              ";";

        }

        for (int i = 74; i < jsonResponse.length; i++) {
          print(route2[i]['station']);
          print(route2[i]['order']);
          print(route2[i]['route']);
          stationQuery6 = stationQuery6 +
              route2[i]["longitude"].toString() +
              "," +
              route2[i]["latitude"].toString() +
              ";";
          stationLocationPoints2.add(new LatLng(
              route2[i]["latitude"],  route2[i]["longitude"]));
        }


        stationQuery3 = stationQuery3.substring(0,
            stationQuery3.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery3, false,true);

        stationQuery4 = stationQuery4.substring(0,
            stationQuery4.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery4, true,true);

        stationQuery5 = stationQuery5.substring(0,
            stationQuery5.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery5, true,true).then((value) => calculateFullDurationDistanceMulti(true,true));

        stationQuery6 = stationQuery6.substring(0,
            stationQuery6.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery6, true,true).then((value) => calculateFullDurationDistanceMulti(true,true));

        locationController.tripCreatedStatus(true);
        //get correct bus
        await locationController.getRouteBusses(jsonResponse['rout1'][0]['routeID']);
        panelController.open();

        return;
      }else if(route2.length <= 74 && route2.length >50){
        for (int i = 0; i  < 24; i++) {
          print(route2[i]['station']);
          print(route2[i]['order']);
          print(route2[i]['route']);

          stationQuery3 = stationQuery3 +
              route2[i]["longitude"].toString() +
              "," +
              route2[i]["latitude"].toString() +
              ";";

        }
        for (int i = 24; i  < 49; i++) {
          print(route2[i]['station']);
          print(route2[i]['order']);
          print(route2[i]['route']);

          stationQuery4 = stationQuery4 +
              route2[i]["longitude"].toString() +
              "," +
              route2[i]["latitude"].toString() +
              ";";

        }
        for (int i = 49; i  < route2.length; i++) {
          print(route2[i]['station']);
          print(route2[i]['order']);
          print(route2[i]['route']);

          stationQuery5 = stationQuery5 +
              route2[i]["longitude"].toString() +
              "," +
              route2[i]["latitude"].toString() +
              ";";

        }

        stationQuery3 = stationQuery3.substring(0,
            stationQuery3.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery3, false,true);

        stationQuery4 = stationQuery4.substring(0,
            stationQuery4.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery4, true,true);
        stationQuery5 = stationQuery5.substring(0,
            stationQuery5.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery5, true,true).then((value) => calculateFullDurationDistanceMulti(true,true));
        locationController.tripCreatedStatus(true);
        //get correct bus
        await locationController.getRouteBusses(jsonResponse['rout1'][0]['routeID']);
        panelController.open();
        return;
      }else if(route2.length <= 50 && route2.length >25){
        for (int i = 0; i  < 24; i++) {
          print(route2[i]['station']);
          print(route2[i]['order']);
          print(route2[i]['route']);

          stationQuery3 = stationQuery3 +
              route2[i]["longitude"].toString() +
              "," +
              route2[i]["latitude"].toString() +
              ";";

        }
        for (int i = 24; i  < route2.length; i++) {
          print(route2[i]['station']);
          print(route2[i]['order']);
          print(route2[i]['route']);

          stationQuery4 = stationQuery4 +
              route2[i]["longitude"].toString() +
              "," +
              route2[i]["latitude"].toString() +
              ";";

        }
        print(route2.length);
        stationQuery3 = stationQuery3.substring(0,
            stationQuery3.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery3, false,true);

        stationQuery4 = stationQuery4.substring(0,
            stationQuery4.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery4, true,true).then((value) => calculateFullDurationDistanceMulti(true,true));
        locationController.tripCreatedStatus(true);
        //get correct bus
        await locationController.getRouteBusses(jsonResponse['rout1'][0]['routeID']);
        panelController.open();
        return;
      }else if(route2.length <= 25){
        print('route 2 <25 =========');
        for (int i = 0; i  < route2.length; i++) {
          print('route 2...  ${route2[i]['station']}');
          print(route2[i]['order']);
          print(route2[i]['route']);

          stationQuery3 = stationQuery3 +
              route2[i]["longitude"].toString() +
              "," +
              route2[i]["latitude"].toString() +
              ";";
        }
        stationQuery3 = stationQuery3.substring(0,
            stationQuery3.length - 1); // To remove the last semicolon from the string (would cause an error)
        await findStationDirectionMulti(stationQuery3, false,true);
        calculateFullDurationDistanceMulti(false,true);
        locationController.tripCreatedStatus(true);
        //get correct bus
        await locationController.getRouteBusses(jsonResponse['rout1'][0]['routeID']);
        panelController.open();
        update();
        return;
      }

      //
      print('======================================== d');
      //add mark for first station
     

    }

  }

  updatePinPos(double lat, double lng) {
    latPinLoc.value = lat;
    lngPinLoc.value = lng;
    update();
  }

  //
  calculateFullDurationDistanceMulti(bool isLong ,bool isRoute2)async{
    if(isRoute2){
      if(isLong){

        fullDurationTrip.value = fullDurationTrip.value + secondRoute2DurationTrip.value;
        fullDistanceTrip.value = fullDistanceTrip.value + secondRoute2DistanceTrip.value;
      }else{

        fullDurationTrip.value = fullDurationTrip.value + secondRouteDurationTrip.value;
        fullDistanceTrip.value = fullDistanceTrip.value + secondRouteDistanceTrip.value;
      }



    }else {
      if(isLong){
        ///

        fullDurationTrip.value = fullDurationTrip.value + route2DurationTrip.value;
        fullDistanceTrip.value = fullDistanceTrip.value + route2DistanceTrip.value;
      }else{
        fullDurationTrip.value = fullDurationTrip.value + routeDurationTrip.value;
        fullDistanceTrip.value = fullDistanceTrip.value + routeDistanceTrip.value;

      }

    }
    ///to do cal walking
    fullDurationTrip.value = fullDurationTrip.value + tripFirstWalkDirData['routes'][0]['duration']/ 60/2;
    fullDistanceTrip.value = fullDistanceTrip.value + tripFirstWalkDirData['routes'][0]['distance']/ 1000/2;
    fullDurationTrip.value = fullDurationTrip.value + tripSecondWalkDirData['routes'][0]['duration']/ 60/2;
    fullDistanceTrip.value = fullDistanceTrip.value + tripSecondWalkDirData['routes'][0]['distance']/ 1000/2;
    print("second route dur === ${secondRouteDurationTrip.value}");
    print('-------------------------------------------');
    update();
  }

  calculateFullDurationDistance(bool isLong ,bool isRoute2)async{
    //جمع كمل المدة الزمنية للرحلة
    print('m w duration ${startWalkDurationTrip}');
    print('m w2 duration ${secondWalkDurationTrip}');
    print('m route1 duration ${routeDurationTrip}');
    if(isMultiMode.value ==true){

    }else{
      fullDurationTrip.value =
      ((tripFirstWalkDirData['routes'][0]['duration']) / 60 +
          (tripSecondWalkDirData['routes'][0]['duration']) / 60 +
          (tripStationDirData['routes'][0]['duration']) / 60);
// distance
      fullDistanceTrip.value =
          ((tripFirstWalkDirData['routes'][0]['distance']) /1000 +
              (tripSecondWalkDirData['routes'][0]['distance']) /1000 +
              (tripStationDirData['routes'][0]['distance']) ) /1000;

      if(isLongTrip.value ==true){
        fullDurationTrip.value = fullDurationTrip.value + (tripStationDirData2['routes'][0]['duration']) / 60;
        fullDistanceTrip.value = fullDistanceTrip.value + (tripStationDirData2['routes'][0]['distance']) / 1000;

        update();
      }
    }
    print("full distance :: ${fullDistanceTrip.value}");

    print(' full duration :: ${fullDurationTrip.value}');
  }


  //    save trip
  callSaveTrip() async {

    print('intIndex = $intIndex');
    if(isMultiMode ==false){
      trip.startStationId = tripRouteData['description']['startStation']['id'];
      trip.endStationId = tripRouteData['description']['endStation']['id'];
      trip.routeId = jsonResponse[0]["routeID"];
      trip.routeName = "Route ${jsonResponse[0]["route"]}";

      trip.startPoint.latitude =
      tripRouteData['description']['startPoint']['latitude'];
      trip.startPoint.latitude =
      tripRouteData['description']['startPoint']['longitude'];

      await tripController.saveTrip();
    }else{
      trip.startStationId = multiRouteTripData['startStation']['id'];
      trip.endStationId = multiRouteTripData['endStation']['id'];
      trip.routeId = multiRouteTripData['rout1'][0]['routeID'];
      trip.routeName = multiRouteTripData['rout1'][0]['route'];
      trip.startPoint.latitude =
      multiRouteTripData['startPoint']['latitude'];
      trip.startPoint.longitude =
      multiRouteTripData['startPoint']['longitude'];
      await tripController.saveTrip();
    }

  }

  @override
  void onInit() {
    super.onInit();
  }

}
