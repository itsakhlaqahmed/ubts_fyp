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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCzplyeCw0lqtaAFocCxhhH__-uefHyGQQ',
    appId: '1:402872740988:web:485b4a9b13bb70118eedf9',
    messagingSenderId: '402872740988',
    projectId: 'flutter-test-project-58f59',
    authDomain: 'flutter-test-project-58f59.firebaseapp.com',
    databaseURL: 'https://flutter-test-project-58f59-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-test-project-58f59.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEJXbb0suQh0iWyvFUXJvSLc77iJJFuI8',
    appId: '1:402872740988:ios:213b07dafb0038d28eedf9',
    messagingSenderId: '402872740988',
    projectId: 'flutter-test-project-58f59',
    databaseURL: 'https://flutter-test-project-58f59-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-test-project-58f59.appspot.com',
    iosBundleId: 'com.example.ubtsFyp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEJXbb0suQh0iWyvFUXJvSLc77iJJFuI8',
    appId: '1:402872740988:ios:213b07dafb0038d28eedf9',
    messagingSenderId: '402872740988',
    projectId: 'flutter-test-project-58f59',
    databaseURL: 'https://flutter-test-project-58f59-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-test-project-58f59.appspot.com',
    iosBundleId: 'com.example.ubtsFyp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCzplyeCw0lqtaAFocCxhhH__-uefHyGQQ',
    appId: '1:402872740988:web:485b4a9b13bb70118eedf9',
    messagingSenderId: '402872740988',
    projectId: 'flutter-test-project-58f59',
    authDomain: 'flutter-test-project-58f59.firebaseapp.com',
    databaseURL: 'https://flutter-test-project-58f59-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-test-project-58f59.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAFE0hrrhIm5OVC18r9JN733kv_9I5KMFE',
    appId: '1:402872740988:android:c52c4c7065e91dc78eedf9',
    messagingSenderId: '402872740988',
    projectId: 'flutter-test-project-58f59',
    databaseURL: 'https://flutter-test-project-58f59-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-test-project-58f59.appspot.com',
  );

}