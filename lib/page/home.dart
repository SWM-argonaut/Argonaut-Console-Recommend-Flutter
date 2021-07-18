import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:keyboard_utils/widgets.dart';
import 'package:keyboard_utils/keyboard_options.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:argonaut_console_recommend/configs.dart';

import 'package:argonaut_console_recommend/block/analytics.dart'
    show AnalyticsBloc;
import 'package:argonaut_console_recommend/block/list.dart'
    show SwitchGameListBloc;

import 'package:argonaut_console_recommend/functions/image.dart';

import 'package:argonaut_console_recommend/data_class/search.dart';
import 'package:argonaut_console_recommend/data_class/switch_game.dart';

import 'package:argonaut_console_recommend/widget/filter.dart';

import 'package:argonaut_console_recommend/page/detail.dart';
import 'package:argonaut_console_recommend/page/notification/notification_list.dart';

late Future<bool> _switchGameListInit;
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
    _switchGameListInit = SwitchGameListBloc.initGameList();
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
    backgroundColor: topColor,
    title: TextField(
      maxLines: 1,
      controller: textController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          suffixIcon: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  AnalyticsBloc.onSearch();
                },
              ),
            ],
          ),
          border: InputBorder.none,
          hintText: "타이틀을 검색해주세요",
          hintStyle: TextStyle(color: Colors.white)),
    ),
    // centerTitle: true,
  );
}

LayoutBuilder _home() {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    return Column(children: [
      SearchFilterBar(),
      _buildList(constraints.maxHeight),
    ]);
  });
}

_buildList(double _height) {
  return Container(
      height: _height - 60,
      child: FutureBuilder(
          future: _switchGameListInit,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                // TODO 에러 처리
                return Center(child: Text("Something went wrong..."));
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
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
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
                right: new BorderSide(width: 1.0, color: Colors.white24))),
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
              child: Text("${item?.nintendoStore?.price}원",
                  style: TextStyle(color: Colors.black))),
        )
      ],
    ),
    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
    onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(switchGame: item)));
    },
  );
}
