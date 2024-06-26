// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAaNBSEyq5YQvYI8zkTK4dzcZqTxf9JvaY',
    appId: '1:694168553969:web:8825c6000dfac892d31c50',
    messagingSenderId: '694168553969',
    projectId: 'reddit-5d95a',
    authDomain: 'reddit-5d95a.firebaseapp.com',
    storageBucket: 'reddit-5d95a.appspot.com',
    measurementId: 'G-8HRPJK3C9P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7xfNGG811-5B72IUpisXEFVdyU3nyLdU',
    appId: '1:694168553969:android:13b1e14e317b70b1d31c50',
    messagingSenderId: '694168553969',
    projectId: 'reddit-5d95a',
    storageBucket: 'reddit-5d95a.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAaNBSEyq5YQvYI8zkTK4dzcZqTxf9JvaY',
    appId: '1:694168553969:web:e617c94a814393e5d31c50',
    messagingSenderId: '694168553969',
    projectId: 'reddit-5d95a',
    authDomain: 'reddit-5d95a.firebaseapp.com',
    storageBucket: 'reddit-5d95a.appspot.com',
    measurementId: 'G-C0GPN03S4L',
  );
}
