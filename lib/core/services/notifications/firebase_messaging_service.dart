import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../logger/logger_service.dart';
import 'notification_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LoggerService.info('Background message: ${message.messageId}');
  LoggerService.debug('Background payload: ${message.data}');
}

class FirebaseMessagingService {
  final FirebaseMessaging messaging;
  final NotificationService notificationService;

  FirebaseMessagingService(this.messaging, this.notificationService);

  Future<void> initialize() async {
    await _requestPermission();
    _listenForegroundMessages();
  }

  Future<void> _requestPermission() async {
    await messaging.requestPermission();
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    LoggerService.info('Foreground message: ${message.messageId}');
    LoggerService.debug('Payload: ${message.data}');
    final body = message.notification?.body ?? 'New notification received';
    notificationService.showMessage(body);
  }
}
