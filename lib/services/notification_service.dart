import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void initialize() {
    // Request notification permission devices
    messaging.requestPermission();

    //get token
    messaging.getToken().then((token) {
      print("Firebase Messaging Token: $token");
    });

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      print('Message data: ${message.notification!.body} ');

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Background : ${message.notification!.body} ');
      });
    });
  }
}
