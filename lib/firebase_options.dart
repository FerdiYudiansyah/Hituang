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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCReg2zZbYzFF8awTxz0RtIbOIzyYwseg0',
    appId: '1:842125674562:android:791ece91af0ea6577d45db',
    messagingSenderId: '842125674562',
    projectId: 'hituang',
    storageBucket: 'hituang.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAl9w_G6nctsIOYIh1p7D0rel1LeEHC04M',
    appId: '1:842125674562:ios:2b287aa3a0b0022b7d45db',
    messagingSenderId: '842125674562',
    projectId: 'hituang',
    storageBucket: 'hituang.firebasestorage.app',
    iosBundleId: 'com.example.hituang',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAl9w_G6nctsIOYIh1p7D0rel1LeEHC04M',
    appId: '1:842125674562:ios:2b287aa3a0b0022b7d45db',
    messagingSenderId: '842125674562',
    projectId: 'hituang',
    storageBucket: 'hituang.firebasestorage.app',
    iosBundleId: 'com.example.hituang',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBebjS6pahRg4K2dRPNNp1HlWe6zW-PbpM',
    appId: '1:842125674562:web:b71add122716049e7d45db',
    messagingSenderId: '842125674562',
    projectId: 'hituang',
    authDomain: 'hituang.firebaseapp.com',
    storageBucket: 'hituang.firebasestorage.app',
    measurementId: 'G-XTZRGFXZPM',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBebjS6pahRg4K2dRPNNp1HlWe6zW-PbpM',
    appId: '1:842125674562:web:b71add122716049e7d45db',
    messagingSenderId: '842125674562',
    projectId: 'hituang',
    authDomain: 'hituang.firebaseapp.com',
    storageBucket: 'hituang.firebasestorage.app',
    measurementId: 'G-XTZRGFXZPM',
  );

}