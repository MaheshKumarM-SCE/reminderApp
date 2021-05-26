import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:reminder_app/pages/home_page.dart';
import 'package:reminder_app/pages/notification_received_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reminder_app/routes/routes.dart';
import 'package:reminder_app/utils/firebase_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic tests',
      playSound: true,
      defaultColor: Color(0xFF9D50DD),
      ledColor: Color(0xFF9D50DD),
      importance: NotificationImportance.High,
    ),
  ]);

  await FirebaseUtils.loadFirebaseCore();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: PAGE_HOME,
      routes: materialRoutes,
    );
  }
}
