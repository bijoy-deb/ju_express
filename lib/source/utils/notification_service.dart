import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class NotificationService {
  NotificationService._createInstance();
  static NotificationService? _notificationService;
  factory NotificationService() {
    _notificationService ??= NotificationService._createInstance();
    return _notificationService!;
  }
  final localNotifications = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/notification_icon');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    localNotifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    localNotifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()?.requestPermissions();
    await localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotification,
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    showLocalNotification(body: body!, id: id, title: title!, data: payload);
    return Future(() => null);
  }

  Future selectNotification(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null &&
        notificationResponse.payload!.isNotEmpty) {
      behaviorSubject.add(notificationResponse.payload!);
    }
    return Future(() => null);
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      color: Color(0xff00AEEf),
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      threadIdentifier: "thread1",
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  Future<void> showLocalNotification(
      {required int id,
      required String title,
      required String body,
      String? data}) async {
    final platformChannelSpecifics = await _notificationDetails();
    await localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: data,
    );
  }
}
