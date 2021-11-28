import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //ensures only one instance of a class
  static final NotificationService _notification = NotificationService.internal();
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notification;
  }

  //configures specific platform initialization
  //currently only configures Android version
  Future<void> init() async {
    //android initializing settings. Passes image for notification icon
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null,
        macOS: null,
      );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (payload) async {});

  }

  Future<void> scheduleNotification({int id = 0, String? title, String? body, String? payload, required DateTime scheduledDate}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }


  NotificationService.internal();

}