import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationReceivedPage extends StatelessWidget {
  const NotificationReceivedPage(this.receivedNotification, {Key? key}) : super(key: key);

  final ReceivedNotification receivedNotification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        title: Text(
          'Notification',
        ),
        leading: BackButton(
            color: Colors.white, onPressed: () => Navigator.of(context).pop()),
      ),
      body: Center(
        child: Text(
          'Notification Tapped',
        ),
      ),
    );
  }
}
