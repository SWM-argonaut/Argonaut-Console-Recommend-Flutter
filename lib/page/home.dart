import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:argonaut_console_recommend/configs.dart';

import 'package:argonaut_console_recommend/block/api.dart';

import 'package:argonaut_console_recommend/functions/image.dart';

import 'package:argonaut_console_recommend/data_class/search.dart';
import 'package:argonaut_console_recommend/data_class/api.dart';

import 'package:argonaut_console_recommend/page/detail.dart';
import 'package:argonaut_console_recommend/page/notification/notification_list.dart';

SearchOptionsNotifier searchOptionsNoti =
    SearchOptionsNotifier(SearchOptions());

late Future<List<SwitchGame>> switchGameList;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    switchGameList = getSwitchGameList(searchOptionsNoti.value);
  }

  int _selectedIndex = 0;
  static List<Text> _titles = [
    Text("닌텐도 스위치 게임 추천", style: TextStyle(color: Colors.white)),
    Text("알림", style: TextStyle(color: Colors.white)),
    Text("북마크", style: TextStyle(color: Colors.white)),
    Text("설정", style: TextStyle(color: Colors.white)),
  ];
  static List<Color> _appBarColor = [
    Color.fromRGBO(1, 177, 209, 1),
    notificationColor,
    favoriteColor,
    settingColor,
  ];
  static List<Widget> _tabs = <Widget>[
    _home(),
    PushList(),
    Center(
      child: Text(
        "준비중입니다.",
        style: TextStyle(color: Colors.white),
      ),
    ),
    Center(
      child: Text(
        "준비중입니다.",
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: _appBarColor.elementAt(_selectedIndex),
        title: _titles.elementAt(_selectedIndex),
        // centerTitle: true,
      ),
      body: _tabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "home",
              backgroundColor: Color.fromRGBO(254, 96, 84, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "notifications",
              backgroundColor: notificationColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "favorite",
              backgroundColor: favoriteColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "settings",
              backgroundColor: settingColor),
        ],
      ),
    );
  }
}

LayoutBuilder _home() {
  return LayoutBuilder(builder: (BuildContext context, constraints) {
    const double _optionHeight = 50;

    double _height = constraints.maxHeight;
    double _width = constraints.maxWidth;

    return Column(children: [
      _options(context, _optionHeight, _width),
      Container(height: _height - _optionHeight, child: _buildList()),
    ]);
  });
}

Row _options(BuildContext context, double _height, double _width) {
  const double _iconWidth = 50;

  return Row(children: [
    Container(
      height: _height,
      width: _width - _iconWidth,
      child: ValueListenableBuilder(
          valueListenable: searchOptionsNoti, builder: _orderListBuilder),
    ),
    Container(
        height: _height,
        width: _iconWidth,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: ElevatedButton(
          child: Icon(Icons.arrow_drop_down_circle_outlined),
          style: ElevatedButton.styleFrom(primary: Colors.transparent),
          onPressed: () {
            showDialog(context: context, builder: _optionDetailBuilder);
          },
        ))
  ]);
}

AlertDialog _optionDetailBuilder(BuildContext context) {
  // TODO 이거 참조해서 할거 https://stackoverflow.com/questions/53913192/flutter-change-the-width-of-an-alertdialog

  return AlertDialog(
    scrollable: true,
    title: Text('Login'),
    content: Form(
      child: Text("여기서 태그 수정하게 만들거"),
    ),
    actions: [
      ElevatedButton(
          child: Text("확인"),
          onPressed: () {
            Navigator.pop(context);
          })
    ],
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
            onPressed: () => searchOptionsNoti.clicked(_order),
            child: _child,
            style:
                ElevatedButton.styleFrom(primary: _butttonColor, elevation: 10),
          ));
    },
  );
}

_buildList() {
  return FutureBuilder(
      future: switchGameList,
      builder:
          (BuildContext context, AsyncSnapshot<List<SwitchGame>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            // TODO 에러 처리
            return Center(child: Text("Something went wrong..."));
          }

          if (snapshot.data?.length == 0) {
            return Center(child: Text("서버와 통신이 되지 않습니다."));
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildCard(context, snapshot.data?[index]);
            },
          );
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
  const Color _progressIndicatorColor = Color.fromRGBO(209, 224, 224, 0.2);
  const Color _progressIndicatorValueColor = Colors.green;

  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        width: 120,
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: getThumbnail(item)),
    title: Text(
      "${item?.title}",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    subtitle: Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              child: LinearProgressIndicator(
                backgroundColor: _progressIndicatorColor,
                value: (item?.coupang?.rating ?? 0).toDouble() / 100,
                valueColor:
                    AlwaysStoppedAnimation(_progressIndicatorValueColor),
              ),
            )),
        Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text("${item?.coupang?.price}",
                  style: TextStyle(color: Colors.white))),
        )
      ],
    ),
    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(switchGame: item)));
    },
  );
}
