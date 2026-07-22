// File generated for EDUING App
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
        return ios;
      default:
        return android;
    }
  }

  static const String _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'eduing-app');
  static const String _messagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '100000000000');
  static const String _storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'eduing-app.appspot.com');

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_WEB_API_KEY', defaultValue: 'AIzaSyA1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p6'),
    appId: String.fromEnvironment('FIREBASE_WEB_APP_ID', defaultValue: '1:100000000000:web:eduingapp12345'),
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    authDomain: 'eduing-app.firebaseapp.com',
    storageBucket: _storageBucket,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_ANDROID_API_KEY', defaultValue: 'AIzaSyA1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p6'),
    appId: String.fromEnvironment('FIREBASE_ANDROID_APP_ID', defaultValue: '1:100000000000:android:eduingapp12345'),
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_IOS_API_KEY', defaultValue: 'AIzaSyA1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p6'),
    appId: String.fromEnvironment('FIREBASE_IOS_APP_ID', defaultValue: '1:100000000000:ios:eduingapp12345'),
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
    iosBundleId: 'com.eduing.app',
  );
}
