// TODO 데이터 구조 확정 짓고서 여기 마무리 하는게 좋을듯

import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:argonaut_console_recommend/data_class/api.dart';

void _launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

class DetailPage extends StatelessWidget {
  final Recommendation? recommendation;
  DetailPage({Key? key, required this.recommendation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${recommendation?.title}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          _topContent(context, recommendation),
          _bottomContent(context, recommendation)
        ],
      )),
    );
  }
}

Container _topContent(BuildContext context, Recommendation? recommendation) {
  return Container(
    // TODO 이미지 보여주기
    child: Text("hi"),
  );
}

Container _bottomContent(BuildContext context, Recommendation? recommendation) {
  return Container(
    padding: EdgeInsets.all(10.0),
    child: Column(
      children: <Widget>[
        ExpandablePanel(
          header: Text(
            "description",
            style: TextStyle(color: Colors.white),
          ),
          collapsed: Text(
            "${recommendation?.description}",
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          ),
          expanded: Text("${recommendation?.description}",
              softWrap: true, style: TextStyle(color: Colors.white)),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () => _launchURL("${recommendation?.coupang?.url}"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(58, 66, 86, 1.0)),
              child: Text("쿠팡에서 구매", style: TextStyle(color: Colors.white)),
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () =>
                  _launchURL("${recommendation?.nintendoStore?.url}"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(58, 66, 86, 1.0)),
              child:
                  Text("닌텐도 스토어에서 구매", style: TextStyle(color: Colors.white)),
            ))
      ],
    ),
  );
}
