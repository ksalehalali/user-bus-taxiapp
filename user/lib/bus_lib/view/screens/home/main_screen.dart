import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as loc ;
import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../../Assistants/assistantMethods.dart';
import '../../../Assistants/globals.dart';
import '../../../Data/current_data.dart';
import '../../../controller/lang_controller.dart';
import '../../../controller/location_controller.dart';
import '../../../controller/packages_controller.dart';
import '../../../controller/payment_controller.dart';
import '../../../controller/route_map_controller.dart';
import '../../../controller/start_up_controller.dart';
import '../../../model/location.dart';
import '../wallet/direct_pay.dart';
import 'Home.dart';
import '../profile/help_screen.dart';
import '../profile/profile_screen.dart';
import '../routes/all_routes_map.dart';
import '../wallet/wallet_screen.dart';

class  MainScreen extends StatefulWidget {
  int indexOfScreen = 0;
  MainScreen({Key? key,required this.indexOfScreen}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

  final List<Widget> screens = [
    Home(),
    DirectPay(),
    WalletScreen(),
    AllRoutesMap(),
    ProfileScreen(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Home();
  final StartUpController startUpController = Get.find();
  final LangController langController = Get.find();

  int? currentTp = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locatePosition();
    autoLang();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Colors.blue,
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      Duration(seconds: 1),
          () => _fabAnimationController.forward(),
    );
    Future.delayed(
      Duration(seconds: 1),
          () => _borderRadiusAnimationController.forward(),
    );
  }

  void autoLang()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final packagesController =
    Get.putAsync(() async => PackagesController(), permanent: true);

    var lang = await prefs.getString('lang');
    print("lang ====== lang === $lang");
    if(lang !=null){
      langController.changeLang(lang);
      Get.updateLocale(Locale(lang));
      langController.changeDIR(lang);
      print(Get.deviceLocale);
      print(Get.locale);
    }
  }
  var location = loc.Location();
  final routeMapController = Get.put(RouteMapController());
  geo.Position? currentPosition;
  double bottomPaddingOfMap = 0;
  final LocationController locationController = Get.find();

  late loc.PermissionStatus _permissionGranted;

  void locatePosition() async {
    loc.Location location = loc.Location.instance;
    geo.Position? currentPos;
    loc.PermissionStatus permissionStatus = await location.hasPermission();
    _permissionGranted = permissionStatus;
    if (_permissionGranted != loc.PermissionStatus.granted) {
      final loc.PermissionStatus permissionStatusReqResult =
      await location.requestPermission();

      _permissionGranted = permissionStatusReqResult;
    }

    setState(() {
      currentScreen = screens[widget.indexOfScreen];
      currentTp = widget.indexOfScreen;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    geo.Position position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    print("--------------------position $position");


    trip.startPoint.latitude = position.latitude;
    trip.startPoint.longitude = position.longitude;
    routeMapController.startPointLatLng.value.latitude = position.latitude;
    routeMapController.startPointLatLng.value.longitude = position.longitude;
    initialPoint.latitude = position.latitude;
    initialPoint.longitude = position.longitude;
    initialPointToFirstMap.latitude = position.latitude;
    initialPointToFirstMap.longitude = position.longitude;
    homeMapController!.animateCamera(
        google_maps.CameraUpdate.newCameraPosition(google_maps.CameraPosition(target: google_maps.LatLng(position.latitude,position.longitude,),zoom: 14)));
    currentPosition = geo.Position(longitude: position.longitude, latitude: position.latitude, timestamp: position.timestamp, accuracy: position.accuracy, altitude: position.altitude, heading: position.heading, speed: position.speed, speedAccuracy: position.speedAccuracy);
    locationController.currentLocation.value = LatLng(position.latitude,position.longitude);
    locationController.currentLocationG.value = google_maps.LatLng(position.latitude,position.longitude);
    routeMapController.startPointLatLng.value = LatLng(position.latitude,position.longitude);
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    if(locationController.startAddingPickUp.value ==false){
      var assistantMethods = AssistantMethods();
      String address =
      await assistantMethods.searchCoordinateAddress(currentPosition!,true);
      trip.startPointAddress = address;
      trip.startPoint = LocationModel(latLngPosition.latitude, latLngPosition.longitude);
      locationController.gotMyLocation(true);
      locationController.changePickUpAddress(address);
      locationController.addPickUp.value = true;

    }

  }

  //icons nav bar
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.payment_sharp,
    Icons.account_balance_wallet_outlined,
    Icons.alt_route_sharp,
    Icons.person,

  ];

  final barTextList=[
    'home_btn'.tr,
    'pay_btn'.tr,
    'wallet_btn'.tr,
    'routes_btn'.tr,
    'profile_btn'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    setState(() {

    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: routes_color,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: routes_color,
        systemNavigationBarDividerColor: Colors.yellow
    ));
    return SafeArea(
      child: Scaffold(
          body: PageStorage(bucket: bucket, child: currentScreen,

          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar:
          AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              final color = isActive ? Colors.black87 : Colors.black26;
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconList[index],
                    size: 24,
                    color: color,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AutoSizeText(
                      "${barTextList[index]}",
                      maxLines: 1,
                      style: TextStyle(color: color),
                      group: autoSizeGroup,
                    ),
                  )
                ],
              );
            },
            backgroundColor: Colors.white,
            activeIndex: _bottomNavIndex,
            splashColor: routes_color7,
            notchAndCornersAnimation: borderRadiusAnimation,
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.defaultEdge,
            gapLocation: GapLocation.none,
            leftCornerRadius: 2,
            rightCornerRadius: 2,
            onTap: (index) => setState(() {
              _bottomNavIndex = index;
              currentScreen =screens[index];
            }),
            hideAnimationController: _hideBottomBarAnimationController,
            shadow: BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 3,
              spreadRadius: 0.1,
              color: routes_color,
            ),
          )

      ),
    );
  }
}
