import 'dart:io';
import 'package:flutter/material.dart';

import 'package:reminder_app/utils/utils.dart';
import 'package:reminder_app/utils/firebase_utils.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TimeOfDay? _pickedTime;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      requestNotificationPermission();
      FirebaseUtils.initializeFirebaseService(context);
      _startListenAwesomeStreams();
    });
  }

  Future<bool> requestNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await showRequestUserPermissionDialog(context);
      isAllowed = await AwesomeNotifications().isNotificationAllowed();
    }
    return isAllowed;
  }

  _startListenAwesomeStreams() async {
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      Fluttertoast.showToast(
          msg: 'Msg: ${StringUtils.isNullOrEmpty(receivedNotification.buttonKeyPressed, considerWhiteSpaceAsEmpty: true) ? 'normal tap' : receivedNotification.buttonKeyPressed}',
          backgroundColor: Colors.blue[200],
          textColor: Colors.black);

      processDefaultActionReceived(context, receivedNotification);
    });
  }

  Future<bool> pickScheduleDate(BuildContext context) async {
    TimeOfDay? timeOfDay;
    timeOfDay = await showTimePicker(
      context: context,
      initialTime: _pickedTime ?? TimeOfDay.now(),
    );
    if (timeOfDay != null) _pickedTime = timeOfDay;
    return true;
  }

  scheduleSleepReminder(TimeOfDay _pickedTime) async {
    DateTime _dateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, _pickedTime.hour, _pickedTime.minute);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        if (!await AwesomeNotifications()
            .requestPermissionToSendNotifications()) {
          print('Notifications are not authorized');
          return;
        }
      }
      await showNotificationWithActionButtons(
        1,
        _dateTime,
      );
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        title: Text(
          'Sleep reminder',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: size.height * 0.02,
          bottom: size.height * 0.02,
          left: size.width * 0.05,
          right: size.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.02,
                bottom: size.height * 0.02,
                left: size.width * 0.05,
                right: size.width * 0.05,
              ),
              child: Container(
                child: Image.asset(
                  'assets/sleep.jpeg',
                ),
              ),
            ),
            Text(
              'Good sleep can improve concentration and productivity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.height * 0.020,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: size.height * 0.045,
                bottom: size.height * 0.02,
                left: size.width * 0.05,
                right: size.width * 0.05,
              ),
              child: Column(
                children: [
                  Text(
                    'To create sleep reminder, Click the below button & enter your sleeping time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.height * 0.020,
                      color: Colors.grey,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(await requestNotificationPermission()){
                        if (await pickScheduleDate(context) &&
                            _pickedTime != null) {
                          await scheduleSleepReminder(_pickedTime!);
                        }
                      }
                    },
                    child: Text(
                      'Create sleep reminder',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                bottom: size.height * 0.02,
                left: size.width * 0.05,
                right: size.width * 0.05,
              ),
              child: TextButton(
                onPressed: () async {
                  showRequestUserPermissionDialog(context);
                },
                child: Text(
                  'Show notification request',
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                bottom: size.height * 0.02,
                left: size.width * 0.05,
                right: size.width * 0.05,
              ),
              child: TextButton(
                onPressed: () async {
                  listScheduledNotifications(context);
                },
                child: Text(
                  'List all active schedules',
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () async {
                  cancelAllSchedules();
                },
                child: Text(
                  'Cancel all active schedules',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
