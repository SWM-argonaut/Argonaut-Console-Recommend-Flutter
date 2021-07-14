// TODO 조르기 기능 추가 (카톡으로 구매 링크 보내기)

import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:argonaut_console_recommend/block/firebase.dart'
    show AnalyticsBloc;

import 'package:argonaut_console_recommend/data_class/api.dart';

import 'package:argonaut_console_recommend/functions/image.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics();

void _launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

class DetailPage extends StatefulWidget {
  final SwitchGame? switchGame;
  const DetailPage({Key? key, required this.switchGame}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with RouteAware {
  static const String routeName = '/detail';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AnalyticsBloc.observer
        .subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPush() {
    super.didPush();
    AnalyticsBloc.observer.analytics.setCurrentScreen(
        screenName: "${routeName}/${widget.switchGame?.title}");
  }

  @override
  void didPopNext() {
    super.didPopNext();
    AnalyticsBloc.observer.analytics.setCurrentScreen(
        screenName: "${routeName}/${widget.switchGame?.title}");
  }

  @override
  void dispose() {
    AnalyticsBloc.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.switchGame?.title}",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: LayoutBuilder(builder: (BuildContext context, constraints) {
        return SingleChildScrollView(
            child: Column(
          children: <Widget>[
            _photos(context, widget.switchGame, constraints),
            _content(context, widget.switchGame),
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
        _rating(switchGame),
        _description(switchGame),
        _buy(context, switchGame),
      ],
    ),
  );
}

Widget _rating(SwitchGame? switchGame) {
  const Color _ratingBackgroundColor = Colors.grey;
  const Color _ratingValueColor = Colors.amber;

  if (switchGame?.coupang == null || switchGame?.coupang?.rating == null) {
    return Container();
  }

  return Row(children: [
    Padding(
        padding: EdgeInsets.all(10),
        child: RatingBarIndicator(
          rating: (switchGame?.coupang?.rating ?? 0).toDouble() / 20,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: _ratingValueColor,
          ),
          itemCount: 5,
          itemSize: 30.0,
          unratedColor: _ratingBackgroundColor,
          direction: Axis.horizontal,
        )),
    Text("${switchGame?.coupang?.ratingCount}")
  ]);
}

ExpandablePanel _description(SwitchGame? switchGame) {
  return ExpandablePanel(
    header: Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          "상세 설명",
          style: TextStyle(color: Colors.black, fontSize: 15),
        )),
    collapsed: Container(),
    expanded: Text("${switchGame?.nintendoStore?.description}",
        softWrap: true, style: TextStyle(color: Colors.black)),
  );
}

Container _buy(BuildContext context, SwitchGame? switchGame) {
  List<Widget> _widget = [];

  if (switchGame!.coupang != null) {
    _widget.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: Text("쿠팡 가격 : ${switchGame.coupang?.price}")),
        Row(children: [
          Container(width: 50, child: Image.asset("assets/images/rocket.png")),
          Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(66, 133, 244, 1.0)),
                child: Text("쿠팡에서 구매", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  analytics.logEvent(
                      name: "store_opened",
                      parameters: <String, dynamic>{
                        "store": "coupang",
                        "idx": "${switchGame.idx}",
                        "title": "${switchGame.title}",
                      });
                  _launchURL("${switchGame.coupang?.url}");
                },
              ))
        ]),
      ],
    ));
  }

  if (switchGame.nintendoStore != null) {
    _widget.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: Text("스토어 가격 : ${switchGame.nintendoStore?.price}")),
        Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(230, 0, 17, 1.0)),
              child:
                  Text("닌텐도 스토어에서 구매", style: TextStyle(color: Colors.white)),
              onPressed: () {
                analytics.logEvent(
                    name: "store_opened",
                    parameters: <String, dynamic>{
                      "store": "nintendo_store",
                      "idx": "${switchGame.idx}",
                      "title": "${switchGame.title}",
                    });
                _launchURL("${switchGame.nintendoStore?.url}");
              },
            )),
      ],
    ));
  }

  return Container(
      color: Colors.white,
      margin: EdgeInsets.all(5),
      child: Column(
        children: _widget,
      ));
}

Widget _bottomContent() {
  return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(top: 140),
      child: Text("이 앱은 쿠팡 파트너스 활동의 일환으로, 이에 따른 일정액의 수수료를 제공받습니다."));
}
