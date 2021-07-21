import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:localstorage/localstorage.dart';

import 'package:console_game_db/configs.dart' show notificationColor;

import 'package:console_game_db/data_class/notificationItem.dart';
import 'package:console_game_db/page/notification/notification_detail.dart';

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
                  return _buildCard(context, _items[index], index);
                });
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

Card _buildCard(BuildContext context, NotificationItem item, int index) {
  return Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
      child: _buildListTile(context, item),
    ),
  );
}

ListTile _buildListTile(BuildContext context, NotificationItem item) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    title: Text(
      "${item.title}",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    subtitle: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Text("${item.body}", style: TextStyle(color: Colors.white))),
    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PushDetail(item: item)));
    },
  );
}
