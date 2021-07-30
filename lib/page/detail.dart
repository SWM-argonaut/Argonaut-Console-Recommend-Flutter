// TODO 조르기 기능 추가 (카톡으로 구매 링크 보내기)

import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:console_game_db/configs.dart';

import 'package:console_game_db/block/list.dart' show SwitchGameListBloc;
import 'package:console_game_db/block/analytics.dart' show AnalyticsBloc;

import 'package:console_game_db/widget/ads.dart';

import 'package:console_game_db/data_class/search.dart';

import 'package:console_game_db/functions/number.dart';

import 'package:console_game_db/data_class/switch_game.dart';

import 'package:console_game_db/functions/image.dart';

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
    AnalyticsBloc.observer.analytics
        .setCurrentScreen(screenName: "$routeName/${widget.switchGame?.title}");
  }

  @override
  void didPopNext() {
    super.didPopNext();
    AnalyticsBloc.observer.analytics
        .setCurrentScreen(screenName: "$routeName/${widget.switchGame?.title}");
  }

  @override
  void dispose() {
    AnalyticsBloc.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AnalyticsBloc.onDetail(widget.switchGame?.idx, widget.switchGame?.title);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.switchGame?.title}",
            style: TextStyle(
              color: Colors.black,
            )),
        centerTitle: true,
      ),
      body: Stack(children: [
        Container(),
        LayoutBuilder(builder: (BuildContext context, constraints) {
          return SingleChildScrollView(
              child: Column(
            children: <Widget>[
              _photos(context, widget.switchGame, constraints),
              _content(context, widget.switchGame),
              _bottomContent(widget.switchGame),
              Container(
                height: 400,
              )
            ],
          ));
        }),
        Positioned(
            bottom: 0,
            child: BannerAdWidget(
              bannerAdUnitId: bottomBannerAdUnitId,
            ))
      ]),
    );
  }
}

Container _photos(
    BuildContext context, SwitchGame? switchGame, BoxConstraints constraints) {
  return Container(
      height: constraints.maxHeight / 3,
      child: ImagePageView(item: switchGame));
}

Container _content(BuildContext context, SwitchGame? switchGame) {
  return Container(
    padding: EdgeInsets.all(10.0),
    child: Column(
      children: <Widget>[
        _rating(switchGame),
        _info(switchGame),
        _description(switchGame),
        _links(context, switchGame),
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

  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
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
      Text(
        "(${switchGame?.coupang?.ratingCount})",
        style: TextStyle(fontSize: 13),
      )
    ],
  );
}

ExpandablePanel _info(SwitchGame? switchGame) {
  return ExpandablePanel(
    header: Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          "게임 정보",
          style: TextStyle(color: Colors.black, fontSize: 15),
        )),
    collapsed: Container(),
    expanded: Text(
      switchGame!.getInfo(),
      softWrap: true,
      style: TextStyle(color: Colors.black),
    ),
  );
}

ExpandablePanel _description(SwitchGame? switchGame) {
  return ExpandablePanel(
    header: Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          "게임 소개",
          style: TextStyle(color: Colors.black, fontSize: 15),
        )),
    collapsed: Text(
      "${switchGame?.nintendoStore?.description}",
      softWrap: true,
      style: TextStyle(color: Colors.black),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ),
    expanded: Text(
      "${switchGame?.nintendoStore?.description}",
      softWrap: true,
      style: TextStyle(color: Colors.black),
    ),
  );
}

Container _links(BuildContext context, SwitchGame? switchGame) {
  List<Widget> _widget = [Padding(padding: EdgeInsets.all(15))];

  if (switchGame?.coupang != null) {
    _widget.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: _priceWidget(
              price: switchGame!.coupang!.price!,
              salePrice: switchGame.coupang!.salePrice,
              shopName: "쿠팡",
            )),
        Row(children: [
          Container(width: 50, child: Image.asset("assets/images/rocket.png")),
          Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(66, 133, 244, 1.0)),
                child: Text("쿠팡 링크", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  AnalyticsBloc.onCoupang(switchGame.idx, switchGame.title);
                  _launchURL("${switchGame.coupang?.url}");
                },
              ))
        ]),
      ],
    ));
  }

  if (switchGame?.nintendoStore != null) {
    _widget.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: _priceWidget(
              price: switchGame!.nintendoStore!.price!,
              salePrice: switchGame.nintendoStore!.salePrice,
              shopName: "e샵",
            )),
        Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(230, 0, 17, 1.0)),
              child: Text("e샵 링크", style: TextStyle(color: Colors.white)),
              onPressed: () {
                AnalyticsBloc.onNintendoStore(switchGame.idx, switchGame.title);
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

Widget _bottomContent(SwitchGame? switchGame) {
  if (switchGame?.coupang != null && switchGame?.coupang?.isPartner == true) {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.all(20),
        child: Text(
          "해당 앱에서는 쿠팡 파트너스 링크를 통하여 구매 링크를 제공하며, 이에 따라 개발자는 소정의 수수료를 쿠팡으로부터 제공 받을 수 있습니다. 이는 사용자의 구매 가격에 영향을 끼치지 않습니다.",
          style: TextStyle(fontSize: 12),
        ));
  }
  return Container();
}

Widget _priceWidget(
    {required int price, int? salePrice, required String shopName}) {
  if (salePrice != null) {
    int? _discountRate = ((price - salePrice) / price * 100).toInt();
    return Row(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$_discountRate% 할인",
            style: TextStyle(color: Colors.red),
          ),
          Text("$shopName 가격 : "),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${priceString(price)}",
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              decorationThickness: 3,
              fontSize: 10,
            ),
          ),
          Text("${priceString(salePrice)}"),
        ],
      )
    ]);
  } else {
    return Text("$shopName 가격 : ${priceString(price)}");
  }
}
