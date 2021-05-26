import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/pages/home_page.dart';
import 'package:reminder_app/pages/notification_received_page.dart';

const String PAGE_HOME = '/';
const String PAGE_NOTIFICATION_RECEIVED = '/notification_received_page';

Map<String, WidgetBuilder> materialRoutes = {
  PAGE_HOME: (context) => HomePage(),
  PAGE_NOTIFICATION_RECEIVED: (context) => NotificationReceivedPage(
        ModalRoute.of(context)!.settings.arguments as ReceivedNotification,
      )
};
