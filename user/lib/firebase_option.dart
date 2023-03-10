import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCcAHa78kdTUAZBKF7m2SQheNXfAuOSghc',
    appId: '1:722270159807:web:ec89dc1c5563d89df1570a',
    messagingSenderId: '722270159807',
    projectId: 'taxi-app-371012',
    authDomain: 'taxi-app-371012.firebaseapp.com',
    storageBucket: 'taxi-app-371012.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXRmV8566HjiPsfliXoZUafmxcWzpBit0',
    appId: '1:722270159807:android:2cd10ab2b1546061f1570a',
    messagingSenderId: '722270159807',
    projectId: 'taxi-app-371012',
    storageBucket: 'taxi-app-371012.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBWRRnSmXrhnZOtC5gmta32t_vzvTGPQUg',
    appId: '1:722270159807:ios:0397550bf804002ff1570a',
    messagingSenderId: '722270159807',
    projectId: 'taxi-app-371012',
    storageBucket: 'taxi-app-371012.appspot.com',
    iosClientId: '722270159807-k8kqjo63ifd56qkn9u1s7vi953ek5i7o.apps.googleusercontent.com',
    iosBundleId: 'com.routesme.userapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBWRRnSmXrhnZOtC5gmta32t_vzvTGPQUg',
    appId: '1:722270159807:ios:0397550bf804002ff1570a',
    messagingSenderId: '722270159807',
    projectId: 'taxi-app-371012',
    storageBucket: 'taxi-app-371012.appspot.com',
    iosClientId: '722270159807-k8kqjo63ifd56qkn9u1s7vi953ek5i7o.apps.googleusercontent.com',
    iosBundleId: 'com.routesme.userapp',
  );
}