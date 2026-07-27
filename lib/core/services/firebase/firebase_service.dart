import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import '../../../firebase_options.dart';
import '../firestore/seed_service.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      analytics.logAppOpen();
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // Seed initial university data on first run
      await SeedService.seedIfEmpty();
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
    }
  }

  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  // Storage disabled until billing is enabled
  // static FirebaseStorage get storage => FirebaseStorage.instance;
  static FirebaseMessaging get messaging => FirebaseMessaging.instance;
}
