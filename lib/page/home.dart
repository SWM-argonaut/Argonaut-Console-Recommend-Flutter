import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/retry.dart';

import 'package:keyboard_utils/widgets.dart';
import 'package:keyboard_utils/keyboard_options.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:console_game_db/configs.dart';

import 'package:console_game_db/block/analytics.dart' show AnalyticsBloc;
import 'package:console_game_db/block/list.dart' show SwitchGameListBloc;

import 'package:console_game_db/functions/image.dart';
import 'package:console_game_db/functions/number.dart';

import 'package:console_game_db/data_class/search.dart';
import 'package:console_game_db/data_class/switch_game.dart';

import 'package:console_game_db/widget/ads.dart';
import 'package:console_game_db/widget/filter.dart';
import 'package:console_game_db/widget/game_list.dart';

import 'package:console_game_db/page/detail.dart';
import 'package:console_game_db/page/notification/notification_list.dart';

late TextEditingController textController;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with RouteAware {
  static const String routeName = '/list';

  @override
  void initState() {
    super.initState();
    SwitchGameListBloc.initGameList();
    textController = SwitchGameListBloc.textController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AnalyticsBloc.observer
        .subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPush() {
    super.didPush();
    AnalyticsBloc.observer.analytics.setCurrentScreen(screenName: routeName);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    AnalyticsBloc.observer.analytics.setCurrentScreen(screenName: routeName);
  }

  @override
  void dispose() {
    AnalyticsBloc.observer.unsubscribe(this);
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      body: _home(),
    );
  }
}

AppBar _appBar(BuildContext context) {
  return AppBar(
    elevation: 0.1,
    leadingWidth: 100,
    leading: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text(
          "콘솔DB",
          style: TextStyle(
              color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
        )),
    title: Container(
        alignment: Alignment.center,
        height: 40,
        child: TextField(
          maxLines: 1,
          controller: textController,
          style: TextStyle(
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
          decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(224, 228, 235, 1),
              contentPadding: EdgeInsets.fromLTRB(25, 10, 10, 10),
              suffixIcon: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      AnalyticsBloc.onSearch();
                    },
                  ),
                ],
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide(color: Colors.white)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "어떤 게임이 궁금하세요?",
              hintStyle: TextStyle(color: Colors.black)),
        )),
    // centerTitle: true,
  );
}

Stack _home() {
  return Stack(
    children: [
      LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Column(children: [
          SearchFilterBar(),
          GameListWidget(height: constraints.maxHeight),
        ]);
      }),
      Positioned(
          bottom: 0,
          child: BannerAdWidget(
            bannerAdUnitId: bottomBannerAdUnitId,
          ))
    ],
  );
}

_buildList(double _height) {
  return Container(
      height: _height - 60,
      child: FutureBuilder(
          future: SwitchGameListBloc.init,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                // TODO 에러 처리
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text("서버와 통신이 되지 않습니다...")),
                      IconButton(
                          onPressed: () {
                            SwitchGameListBloc.initGameList();
                          },
                          icon: Icon(Icons.restart_alt))
                    ]);
              }
              if (snapshot.data! == false) {
                return Center(child: CircularProgressIndicator());
              }
              if (SwitchGameListBloc.itemCount == 0) {
                return Center(child: Text("서버와 통신이 되지 않습니다."));
              }
              return StreamBuilder(
                  stream: SwitchGameListBloc.update.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 100),
                      itemCount: SwitchGameListBloc.filteredItemCount,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildCard(
                            context, SwitchGameListBloc.filteredItems[index]);
                      },
                    );
                  });
            }
          }));
}

Card _buildCard(BuildContext context, SwitchGame? item) {
  return Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
      child: _buildListTile(context, item),
    ),
  );
}

ListTile _buildListTile(BuildContext context, SwitchGame? item) {
  const Color _ratingBackgroundColor = Color.fromRGBO(194, 194, 214, 0.2);
  const Color _ratingValueColor = Colors.amber;

  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white))),
        child: getThumbnail(item)),
    title: Text("${item?.title}",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis),
    subtitle: Row(
      children: <Widget>[
        Expanded(
            flex: 6,
            child: Container(
              child: RatingBarIndicator(
                rating: (item?.coupang?.rating ?? 0).toDouble() / 20,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: _ratingValueColor,
                ),
                itemCount: 5,
                itemSize: 20.0,
                unratedColor: _ratingBackgroundColor,
                direction: Axis.horizontal,
              ),
            )),
        Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(priceString(item?.nintendoStore?.price),
                  style: TextStyle(color: Colors.black))),
        )
      ],
    ),
    onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(switchGame: item)));
    },
  );
}
