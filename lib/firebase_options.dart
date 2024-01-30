// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAMNfQdIYnNVcVo3bi7icSSsB84Ourvw_A',
    appId: '1:521437183373:web:beb49364c1826f1ad211c4',
    messagingSenderId: '521437183373',
    projectId: 'fir-crud-1a968',
    authDomain: 'fir-crud-1a968.firebaseapp.com',
    storageBucket: 'fir-crud-1a968.appspot.com',
    measurementId: 'G-E4DX9RH0C6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZgX5c-gRJozZ1Um4uRh1Eof8nAEhjOlI',
    appId: '1:521437183373:android:6c462f0cc191aa95d211c4',
    messagingSenderId: '521437183373',
    projectId: 'fir-crud-1a968',
    storageBucket: 'fir-crud-1a968.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGvhx67KAYQLE2Etz7Z_iokg_xr4ABMWY',
    appId: '1:521437183373:ios:b7506b93c39f9dcfd211c4',
    messagingSenderId: '521437183373',
    projectId: 'fir-crud-1a968',
    storageBucket: 'fir-crud-1a968.appspot.com',
    iosBundleId: 'com.example.flutterFirebasecrud1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCGvhx67KAYQLE2Etz7Z_iokg_xr4ABMWY',
    appId: '1:521437183373:ios:a2c9f13c54f0182cd211c4',
    messagingSenderId: '521437183373',
    projectId: 'fir-crud-1a968',
    storageBucket: 'fir-crud-1a968.appspot.com',
    iosBundleId: 'com.example.flutterFirebasecrud1.RunnerTests',
  );
}
