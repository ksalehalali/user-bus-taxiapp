import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/functions/notifications.dart';
import 'bus_lib/Assistants/firebase_dynamic_link.dart';
import 'bus_lib/Assistants/globals.dart';
import 'bus_lib/Data/current_data.dart';
import 'bus_lib/controller/confirm_number_controller.dart';
import 'bus_lib/controller/lang_controller.dart';
import 'bus_lib/controller/location_controller.dart';
import 'bus_lib/controller/login_controller.dart';
import 'bus_lib/controller/payment_controller.dart';
import 'bus_lib/controller/personal_information_controller.dart';
import 'bus_lib/controller/sign_up_controller.dart';
import 'bus_lib/controller/start_up_controller.dart';
import 'bus_lib/controller/transactions_controller.dart';
import 'bus_lib/controller/trip_controller.dart';
import 'bus_lib/localization/localization.dart';
import 'bus_lib/view/screens/Auth/login.dart';
import 'bus_lib/view/screens/separator.dart';
import 'firebase_option.dart';
import 'pages/loadingPage/loadingpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: routes_color,
        statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: routes_color,
    systemNavigationBarDividerColor: Colors.yellow
  ));
  checkInternetConnection();

  initMessaging();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    return GestureDetector(
        onTap: () {
          //remove keyboard on touching anywhere on the screen.
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: ScreenUtilInit(
            designSize: Size(390, 815),

            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return GetMaterialApp(
                title: "Go Routes",
                  locale: Locale('en'),
                  fallbackLocale: Locale('en'),
                  translations: Localization(),
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                      fontFamily: 'Poppins'
                  ),
                  home:StreamBuilder<ConnectivityResult>(
                      stream: Connectivity().onConnectivityChanged,
                      builder: (context, snapshot) {
                        return snapshot.data == ConnectivityResult.none ? const Center(child: Text("No Internet")): const MyBusApp();
                      }));

            }
        ));
  }
}
class MyBusApp extends StatefulWidget {
  const MyBusApp({Key? key}) : super(key: key);

  @override
  _MyBusAppState createState() => _MyBusAppState();
}

class _MyBusAppState extends State<MyBusApp> with TickerProviderStateMixin {
  final startUpController = Get.put(StartUpController());
  late final AnimationController _controller;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    // FirebaseMessaging.onBackgroundMessage(
    //     pushNotificationService.firebaseMessagingBackgroundHandler);

    final locationController = Get.put(LocationController());

    final paymentController =
    Get.putAsync(() async => PaymentController(), permanent: true);
    final tripsController =
    Get.putAsync(() async => TripController(), permanent: true);
    final transactionsController =
    Get.putAsync(() async => TransactionsController(), permanent: true);
    final langController =
    Get.putAsync(() async => LangController(), permanent: true);
    final signUpController =
    Get.putAsync(() async => SignUpController(), permanent: true);
    final loginController =
    Get.putAsync(() async => LoginController(), permanent: true);
    final personalInformationController =
    Get.putAsync(() async => PersonalInformationController(), permanent: true);
    final confirmNumberController = Get.putAsync(() async => ConfirmNumberController(), permanent: true);

    // MFSDK.init(
    //     'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL',
    //     MFCountry.KUWAIT,
    //     MFEnvironment.TEST);
    // TODO: implement initState
    super.initState();
    FirebaseDynamicLinkService.initDynamicLink(context);


    getConnectivity();
    start();
    checkConnectivity();
  }



  checkConnectivity()async {
    var isDeviceConnected = await Connectivity().checkConnectivity();
    print('isDeviceConnected :: ${isDeviceConnected.name}');
  }
  start() async {
    await getDetailsOfDevice();
    await getLocalData();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      startUpController.isConnected.value = true;
      // I am connected to a mobile network.
      user.isConnected = true;
      startUpController.fetchUserLoginPreference();
      print('mobile.......');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      startUpController.isConnected.value = true;
      startUpController.fetchUserLoginPreference();

      print('wifi.......');
      user.isConnected = true;

    } else if (connectivityResult == ConnectivityResult.none) {
      // I am connected to a wifi network.
      startUpController.isConnected.value =false;
      print('none.......');
      //user.isConnected = false;
      Get.offAll(() => Login());
      showDialogBoxNoneConnection();
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen((
          ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        print('is Device Connected $isDeviceConnected');
        if (!isDeviceConnected && !isAlertSet) {

          startUpController.isConnected.value = false;

          isAlertSet = true;
          user.isConnected = false;
          Get.offAll(() => Login());
          showDialogBox();
        } else {
          startUpController.isConnected.value = true;
          user.isConnected = true;
          //startUpController.fetchUserLoginPreference();
        }
      },
      );

  showDialogBox() =>
      showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: const Text('No Connection'),
              content: const Text('Please check your internet connectivity'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected) {

                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );

  showDialogBoxNoneConnection() =>
      showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: const Text('No Connection'),
              content: const Text('Please check your internet connectivity'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    // setState(() => isAlertSet = false);
                    isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected) {

                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );





  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            routes_color2,
            routes_color,
          ]),
          color: Colors.white),
      child: SafeArea(
        left: false,
        right: false,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                routes_color6,
                routes_color,
              ]),
              color: Colors.white),
          child: Image.asset(
            'assets/animation/ROUTES-Animated Logo.gif',
            fit: BoxFit.fill,
          ),
          // child: Lottie.asset(
          //   'assets/animation/17314-bus.json',
          //   height: 122,
          //   width: 122,
          //   controller: _controller,
          //   onLoaded: (composition) {
          //     // Configure the AnimationController with the duration of the
          //     // Lottie file and start the animation.
          //     _controller..duration = composition.duration
          //       ..forward();
          //   },
          // ),
        ),
      ),
    );
  }
}