import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart'
    hide DateUtils;
import 'package:awesome_notifications/awesome_notifications.dart' as Utils
    show DateUtils;
import 'package:flutter/material.dart';
import 'package:reminder_app/constants.dart';
import 'package:reminder_app/routes/routes.dart';

Future<bool> showNotificationWithActionButtons(
    int id, DateTime scheduleTime) async {
  return AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Good night! Its time to sleep',
          body: 'Sleep early. Stay healthy.',
          payload: {'uuid': 'user-profile-uuid'}),
      schedule: NotificationCalendar(
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          hour: scheduleTime.hour,
          minute: scheduleTime.minute,
          second: 0,
          allowWhileIdle: true,
          repeats: true),
      actionButtons: [
        NotificationActionButton(
            key: ConstantKey.sleepNow,
            label: 'Okay, Got it',
            enabled: true,
            buttonType: ActionButtonType.Default),
        NotificationActionButton(
            key: ConstantKey.sleepLater,
            label: "I'll sleep later",
            enabled: true,
            buttonType: ActionButtonType.Default)
      ]);
}

Future<bool> showNotificationAtScheduleCron(int id, DateTime scheduleTime) async {
  return AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'scheduled',
        title: 'Just in time!',
        body: 'This notification was schedule to shows at ' +
            (Utils.DateUtils.parseDateToString(scheduleTime.toLocal()) ?? '?') +
            '(' +
            (Utils.DateUtils.parseDateToString(scheduleTime.toUtc()) ?? '?') +
            ' utc)',
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: 'asset://assets/images/delivery.jpeg',
        payload: {'uuid': 'uuid-test'},
        autoCancel: false,
      ),
      schedule: NotificationCalendar(
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          weekday: scheduleTime.weekday,
          hour: scheduleTime.hour,
          minute: scheduleTime.minute,
          second: 0,
          allowWhileIdle: true,
          repeats: true
      ));
}

Future<void> listScheduledNotifications(BuildContext context) async {
  List<PushNotification> activeSchedules =
      await AwesomeNotifications().listScheduledNotifications();
  for (PushNotification schedule in activeSchedules) {
    debugPrint(
        'pending notification: [id: ${schedule.content!.id}, title: ${schedule.content!.titleWithoutHtml}, schedule: ${schedule.schedule.toString()}]');
  }
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text('${activeSchedules.length} schedules founded'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> cancelAllSchedules() async {
  await AwesomeNotifications().cancelAllSchedules();
}

Future<void> showRequestUserPermissionDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (_) =>
        AlertDialog(
          backgroundColor: Color(0xfffbfbfb),
          title: Text('Get Notified!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/animated-bell.gif',
                height: 200,
                fit: BoxFit.fitWidth,
              ),
              Text(
                'Please, you need to allow our notifications to receive alerts',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.grey),
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text('Later', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: () async {
                await AwesomeNotifications()
                    .requestPermissionToSendNotifications();
                Navigator.of(context).pop();
              },
              child: Text('Allow', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
  );
}

void processDefaultActionReceived(BuildContext context, ReceivedAction receivedNotification) {

  // Avoid to open the notification details page over another details page already opened
  Navigator.pushNamedAndRemoveUntil(context, PAGE_NOTIFICATION_RECEIVED,
          (route) => (route.settings.name != PAGE_NOTIFICATION_RECEIVED) || route.isFirst,
      arguments: receivedNotification);
}