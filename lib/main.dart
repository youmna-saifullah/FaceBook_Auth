import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';
import 'app/app_name.dart';
import 'app/injection_container.dart';
import 'core/services/logger/logger_service.dart';
import 'core/services/notifications/firebase_messaging_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  await _setupDependencyInjection();
  await _initializeMessaging();
  runApp(_buildApp());
}

Future<void> _initializeFirebase() async {
  try {
    LoggerService.info('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    LoggerService.success('Firebase initialized successfully');
  } catch (error, stackTrace) {
    LoggerService.error(
      'Failed to initialize Firebase',
      exception: error is Exception ? error : null,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

Future<void> _initializeMessaging() async {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  final service = getIt<FirebaseMessagingService>();
  await service.initialize();
}

Future<void> _setupDependencyInjection() async {
  try {
    setupInjectionContainer();
  } catch (error, stackTrace) {
    LoggerService.error(
      'Failed to setup Dependency Injection',
      exception: error is Exception ? error : null,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

Widget _buildApp() {
  if (!kDebugMode) {
    return const AppName();
  }
  return DevicePreview(
    enabled: true,
    builder: (context) => const AppName(),
  );
}
