import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'app.dart';

// Entry point of the Flutter application
Future<void> main() async {

  // Ensures Flutter is properly initialized before
  // running asynchronous code or using platform services
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase for the Flutter application
  await Firebase.initializeApp(
    // Uses the Firebase configuration according to
    // the current platform (Android, iOS, Web, etc.)
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Starts the Flutter application
  // LegalMetrologyApp is defined in app.dart
  runApp(const LegalMetrologyApp());
}






// flutter pub add firebase_core
// flutter pub add firebase_auth
// flutter pub add cloud_firestore
// flutter pub add firebase_storage
// flutter pub add firebase_messaging
// flutter pub add image_picker
// flutter pub add geolocator
// flutter pub add permission_handler
// flutter pub add intl
// flutter pub add go_router

// flutter pub add pdf
// flutter pub add qr_flutter