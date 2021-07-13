// TODO 조르기 기능 추가 (카톡으로 구매 링크 보내기)

import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';
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
        title:
            Text("${switchGame?.title}", style: TextStyle(color: Colors.white)),
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
  const Color _ratingBackgroundColor = Colors.grey;
  const Color _ratingValueColor = Colors.amber;

  return Container(
    padding: EdgeInsets.all(10.0),
    child: Column(
      children: <Widget>[
        RatingBarIndicator(
          rating: (switchGame?.coupang?.rating ?? 0).toDouble() / 20,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: _ratingValueColor,
          ),
          itemCount: 5,
          itemSize: 50.0,
          unratedColor: _ratingBackgroundColor,
          direction: Axis.horizontal,
        ),
        ExpandablePanel(
          header: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "상세 설명",
                style: TextStyle(color: Colors.black, fontSize: 15),
              )),
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
