import 'package:flutter/material.dart';

import 'package:argonaut_console_recommend/data_class/notificationItem.dart';

const titleStyle = TextStyle(
  fontSize: 50,
);
const bodyStyle = TextStyle(
  fontSize: 30,
);

class PushDetail extends StatefulWidget {
  final NotificationItem? item;

  const PushDetail({Key? key, this.item}) : super(key: key);

  @override
  _PushDetailState createState() => _PushDetailState();
}

class _PushDetailState extends State<PushDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("푸시 앱"),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "title : ${widget.item?.title}\n",
                style: titleStyle,
              ),
              Text(
                "body : ${widget.item?.body}",
                style: bodyStyle,
              )
            ],
          ),
        ));
  }
}
