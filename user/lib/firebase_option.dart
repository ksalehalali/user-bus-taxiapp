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
    apiKey: 'AIzaSyDqr5DtRX73j768ipXbCQF-7Qqix4rn_Vo',
    appId: '1:427832602406:android:2728cf1201827e022ddbe7',
    messagingSenderId: '599030350718',
    projectId: 'routes-user-app',
    authDomain: 'routes-user-app.firebaseapp.com',
    storageBucket: 'routes-user-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqr5DtRX73j768ipXbCQF-7Qqix4rn_Vo',
    appId: '1:427832602406:android:2728cf1201827e022ddbe7',
    messagingSenderId: '427832602406',
    projectId: 'routes-user-app',
    storageBucket: 'routes-user-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAwdwt_QPocr2axk3nj63_gvrTtq_9lPY',
    appId: '1:427832602406:ios:57f31674e34cb85b2ddbe7',
    messagingSenderId: '427832602406',
    projectId: 'routes-user-app',
    storageBucket: 'routes-user-app.appspot.com',
    iosClientId: '427832602406-r06ij4l617glot697f9p4oota8b42ibi.apps.googleusercontent.com',
    iosBundleId: 'com.routestaxi.userapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDAwdwt_QPocr2axk3nj63_gvrTtq_9lPY',
    appId: '1:427832602406:ios:57f31674e34cb85b2ddbe7',
    messagingSenderId: '427832602406',
    projectId: 'routes-user-app',
    storageBucket: 'routes-user-app.appspot.com',
    iosClientId: '427832602406-r06ij4l617glot697f9p4oota8b42ibi.apps.googleusercontent.com',
    iosBundleId: 'com.routestaxi.userapp',
  );
}