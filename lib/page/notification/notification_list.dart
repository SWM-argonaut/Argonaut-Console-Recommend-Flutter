import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:localstorage/localstorage.dart';

import 'package:argonaut_console_recommend/data_class/notificationItem.dart';
import 'package:argonaut_console_recommend/page/notification/notification_detail.dart';

class PushList extends StatefulWidget {
  const PushList({Key? key}) : super(key: key);

  @override
  _PushListState createState() => _PushListState();
}

class _PushListState extends State<PushList> {
  final LocalStorage _storage = new LocalStorage('notifications.json');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == true) {
            List<NotificationItem> _items =
                NotificationItem.listToNotifications(
                    _storage.getItem("notifications"));

            if (_items.length == 0) {
              return Text("빔..");
            }

            return ListView.builder(
                shrinkWrap: true,
                itemCount: _items.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return _itemBuilder(context, _items[index], index);
                });
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

Container _itemBuilder(BuildContext context, NotificationItem item, int index) {
  return Container(
      child: ElevatedButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => PushDetail(item: item))),
          child: Column(
            children: [Text("${item.title}"), Text("${item.body}")],
          )));
}
