// TODO 데이터 구조 확정 짓고서 여기 마무리 하는게 좋을듯

import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:argonaut_console_recommend/data_class/api.dart';
import 'package:argonaut_console_recommend/functions/image.dart';

void _launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

class DetailPage extends StatelessWidget {
  final SwitchGame? switchGame;
  DetailPage({Key? key, required this.switchGame}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${switchGame?.title}"),
        centerTitle: true,
      ),
      body: LayoutBuilder(builder: (BuildContext context, constraints) {
        return SingleChildScrollView(
            child: Column(
          children: <Widget>[
            _photos(context, switchGame, constraints),
            _content(context, switchGame),
            _bottomContent()
          ],
        ));
      }),
    );
  }
}

Container _photos(
    BuildContext context, SwitchGame? switchGame, BoxConstraints constraints) {
  return Container(
      height: constraints.maxHeight / 3, child: imagePageView(switchGame));
}

Container _content(BuildContext context, SwitchGame? switchGame) {
  return Container(
    padding: EdgeInsets.all(10.0),
    child: Column(
      children: <Widget>[
        RatingBarIndicator(
          rating: (switchGame?.coupang?.rating ?? 0).toDouble() / 20,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 50.0,
          direction: Axis.horizontal,
        ),
        ExpandablePanel(
          header: Text(
            "상세 설명",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          collapsed: Container(),
          expanded: Text("${switchGame?.nintendoStore?.description}",
              softWrap: true, style: TextStyle(color: Colors.black)),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () => _launchURL("${switchGame?.coupang?.url}"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(58, 66, 86, 1.0)),
              child: Text("쿠팡에서 구매", style: TextStyle(color: Colors.white)),
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () => _launchURL("${switchGame?.nintendoStore?.url}"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(58, 66, 86, 1.0)),
              child:
                  Text("닌텐도 스토어에서 구매", style: TextStyle(color: Colors.white)),
            ))
      ],
    ),
  );
}

Widget _bottomContent() {
  return Container(
      alignment: Alignment.bottomCenter,
      child: Text("이 앱은 쿠팡 파트너스 활동의 일환으로, 이에 따른 일정액의 수수료를 제공받습니다."));
}
