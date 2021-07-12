import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:keyboard_utils/keyboard_options.dart';

import 'package:keyboard_utils/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:argonaut_console_recommend/configs.dart';

import 'package:argonaut_console_recommend/block/api.dart';
import 'package:argonaut_console_recommend/block/list.dart';

import 'package:argonaut_console_recommend/functions/image.dart';

import 'package:argonaut_console_recommend/data_class/search.dart';
import 'package:argonaut_console_recommend/data_class/api.dart';

import 'package:argonaut_console_recommend/page/detail.dart';
import 'package:argonaut_console_recommend/page/notification/notification_list.dart';

late TextEditingController textController;
final SwitchGameListBloc switchGameListBloc = SwitchGameListBloc();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    textController = switchGameListBloc.textController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: topColor,
        title: Text("닌텐도 스위치 게임 추천", style: TextStyle(color: Colors.white)),
        actions: [
          Container(
              width: 50,
              margin: EdgeInsets.all(7),
              alignment: Alignment.center,
              color: Colors.transparent,
              child: GestureDetector(
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30,
                ),
                onTap: () {
                  showDialog(context: context, builder: _optionDetailBuilder);
                },
              ))
        ],
        // centerTitle: true,
      ),
      body: _home(),
    );
  }
}

LayoutBuilder _home() {
  return LayoutBuilder(builder: (BuildContext context, constraints) {
    const double _optionHeight = 50;
    const double _searchBarHeight = 60;

    double _height = constraints.maxHeight;
    double _width = constraints.maxWidth;

    return Container(
        height: _height,
        width: _width,
        child: Stack(clipBehavior: Clip.none, children: [
          Column(children: [
            _options(context, _optionHeight, _width),
            Container(height: _height - _optionHeight, child: _buildList()),
          ]),
          _searchBar(context, _searchBarHeight, _width),
        ]));
  });
}

Widget _searchBar(BuildContext context, double _height, double _width) {
  return KeyboardAware(
      builder: (BuildContext context, KeyboardOptions keyboard) {
    return Positioned(
        bottom: keyboard.keyboardHeight,
        child: Container(
          height: _height,
          width: _width,
          color: bottomColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: TextField(
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
                        },
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  hintText: "타이틀을 검색해주세요",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
          ),
        ));
  });
}

Container _options(BuildContext context, double _height, double _width) {
  return Container(
      child: Row(children: [
    Container(
      height: _height,
      width: _width,
      child: ValueListenableBuilder(
          valueListenable: switchGameListBloc.switchGameOrderNoti,
          builder: _orderListBuilder),
    ),
  ]));
}

AlertDialog _optionDetailBuilder(BuildContext context) {
  // TODO 이거 참조해서 할거 https://stackoverflow.com/questions/53913192/flutter-change-the-width-of-an-alertdialog

  return AlertDialog(
    scrollable: true,
    title: Text('설정'),
    content: Form(
      child: Text(
        "이 앱은 쿠팡 파트너스 활동의 일환으로, 이에 따른 일정액의 수수료를 제공받습니다.",
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    ),
  );
}

ListView _orderListBuilder(BuildContext context, SearchOptions options, _) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: OrderBy.values.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context, int index) {
      OrderBy _order = OrderBy.values[index];
      Color _butttonColor;
      Widget _child;
      if (options.orderBy == _order) {
        _butttonColor = Colors.green;
        _child = Row(
          children: [
            Text("${OrderBy.values[index]}".split(".").last + " "),
            Icon(options.asc ? Icons.arrow_upward : Icons.arrow_downward)
          ],
        );
      } else {
        _butttonColor = Colors.orange;
        _child = Text("${OrderBy.values[index]}".split(".").last);
      }

      return Padding(
          padding: EdgeInsets.all(3),
          child: ElevatedButton(
            onPressed: () =>
                switchGameListBloc.switchGameOrderNoti.clicked(_order),
            child: _child,
            style:
                ElevatedButton.styleFrom(primary: _butttonColor, elevation: 10),
          ));
    },
  );
}

_buildList() {
  return FutureBuilder(
      future: switchGameListBloc.initGameList(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            // TODO 에러 처리
            return Center(child: Text("Something went wrong..."));
          }

          if (switchGameListBloc.itemCount == 0) {
            return Center(child: Text("서버와 통신이 되지 않습니다."));
          }

          // TODO;
          return StreamBuilder(
              stream: switchGameListBloc.update.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: switchGameListBloc.filteredItemCount,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCard(
                        context, switchGameListBloc.filteredItems[index]);
                  },
                );
              });
        }
      });
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(switchGame: item)));
    },
  );
}
