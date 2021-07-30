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
