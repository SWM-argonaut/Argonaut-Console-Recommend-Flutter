import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:localstorage/localstorage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:argonaut_console_recommend/configs.dart';

import 'package:argonaut_console_recommend/data_class/notificationItem.dart';

import 'package:argonaut_console_recommend/page/home.dart';
import 'package:argonaut_console_recommend/page/notification/notification_detail.dart';

void main() => runApp(new MyApp());

// TODO 강제 업데이트 : https://bebesoft.tistory.com/45

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final _navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    initOneSignal();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      navigatorKey: _navigatorKey,
      title: '닌텐도 스위치 게임 추천',
      theme: new ThemeData(
          scaffoldBackgroundColor: Colors.lime[50],
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.black)),
      home: new Home(),
      // routes: {},
    );
  }

  Future<void> initOneSignal() async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId(OnesiganlAppId);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    // Called when the user opens or taps an action on a notification.
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      _saveNotification(result.notification);
      _navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => PushDetail(
              item: NotificationItem.notification(result.notification))));
    });
  }

  // TODO 원시그널은 플루터를 이용해선 백그라운드에서 메세지를 저장할 수 없다.....
  //      즉, 메세지를 무시하면 저장 안됨...
  _saveNotification(OSNotification notification) async {
    final LocalStorage _storage = new LocalStorage('notifications.json');
    if (await _storage.ready) {
      List<NotificationItem> _items = NotificationItem.listToNotifications(
          _storage.getItem("notifications"));

      _items.add(NotificationItem.notification(notification));

      _storage.setItem(
          'notifications', NotificationItem.listToJSONEncodable(_items));
    }
  }
}
