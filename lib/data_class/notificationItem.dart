import 'dart:convert';

import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationItem {
  String? title, body;

  NotificationItem({required this.title, required this.body});
  NotificationItem.notification(OSNotification notification) {
    this.title = "${notification.title}";
    this.body = "${notification.body}";
  }

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['title'] = title;
    m['body'] = body;
    return m;
  }

  static listToJSONEncodable(List<NotificationItem> items) {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }

  static List<NotificationItem> jsonToNotifications(dynamic json) {
    List<NotificationItem> notifications = [];

    if (json != null) {
      for (var notification in jsonDecode(json)) {
        notifications.add(NotificationItem(
          title: notification['title'],
          body: notification['body'],
        ));
      }
    }

    return notifications;
  }

  static List<NotificationItem> listToNotifications(List<dynamic> list) {
    List<NotificationItem> notifications = [];

    for (var notification in list) {
      notifications.add(NotificationItem(
        title: notification['title'],
        body: notification['body'],
      ));
    }

    return notifications;
  }
}
