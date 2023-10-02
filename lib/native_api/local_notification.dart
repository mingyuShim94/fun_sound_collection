import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class LocalNotification {
  LocalNotification._();

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static initialize() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("mipmap/ic_launcher");

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void requestPermission() {
    print('requestPermission');
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static Future<void> sampleNotification(String sound) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '${sound}sample', //앱에서 다른 알람들과 구분하기 위한 id
      "channel name",
      channelDescription: "channel description",
      sound: RawResourceAndroidNotificationSound(sound),
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    print('sample_notification');
    await _flutterLocalNotificationsPlugin.show(
      0,
      "장난치기좋은소리모음",
      '${sound}sample',
      platformChannelSpecifics,
    );
  }

  static Future<void> timerNotification(String sound, int time, int id) async {
    print('notification');
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '${sound}timer',
      "channel name",
      channelDescription: "channel description",
      sound: RawResourceAndroidNotificationSound(sound),
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    print('timer_notification');

    await _configureLocalTimeZone();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      "장난치기좋은소리모음",
      '${sound}timer',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: time)), // 예약 시간 설정
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    print('cancel_notification');

    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
