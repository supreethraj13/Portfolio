import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    throw UnsupportedError(
      'Firebase is currently configured for Web only. '
      'Run `flutterfire configure` to add Android/iOS/Desktop configs.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyATDFi-UPT42x87PRsVZixYnZisfgb9LaM',
    appId: '1:538323352045:web:684522f2115ef0534bcfe4',
    messagingSenderId: '538323352045',
    projectId: 'portfolio-ebb6c',
    authDomain: 'portfolio-ebb6c.firebaseapp.com',
    storageBucket: 'portfolio-ebb6c.firebasestorage.app',
    measurementId: 'G-3Z0SM8ESCR',
  );
}
