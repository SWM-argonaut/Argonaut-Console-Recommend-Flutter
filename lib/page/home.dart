import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:keyboard_utils/widgets.dart';
import 'package:keyboard_utils/keyboard_options.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:argonaut_console_recommend/configs.dart';

import 'package:argonaut_console_recommend/block/firebase.dart'
    show AnalyticsBloc;
import 'package:argonaut_console_recommend/block/list.dart'
    show SwitchGameListBloc;

import 'package:argonaut_console_recommend/functions/image.dart';

import 'package:argonaut_console_recommend/data_class/search.dart';
import 'package:argonaut_console_recommend/data_class/api.dart';

import 'package:argonaut_console_recommend/page/detail.dart';
import 'package:argonaut_console_recommend/page/notification/notification_list.dart';

late Future<bool> _switchGameListInit;
late TextEditingController textController;
final FirebaseAnalytics analytics = FirebaseAnalytics();

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
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: topColor,
        title: Text("닌텐도 스위치 게임 추천", style: TextStyle(color: Colors.white)),
        actions: [],
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
                          if (SwitchGameListBloc.searchOptions.searchText !=
                              "") {
                            analytics.logEvent(
                                name: "game_search",
                                parameters: <String, dynamic>{
                                  "search_text": SwitchGameListBloc
                                      .searchOptions.searchText,
                                  "search_genres": SwitchGameListBloc
                                      .searchOptions.genres
                                      .toString()
                                      .replaceAll("Genre.", ""),
                                  "search_languages": SwitchGameListBloc
                                      .searchOptions.languages
                                      .toString()
                                      .replaceAll("Language.", ""),
                                  "search_order_by": SwitchGameListBloc
                                      .searchOptions.orderBy
                                      .toString()
                                      .split('.')
                                      .last,
                                  "search_order":
                                      SwitchGameListBloc.searchOptions.asc
                                          ? "ASC"
                                          : "DESC",
                                });
                          }
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
  const double _iconWidth = 50;

  return Container(
      child: Row(children: [
    Container(
      height: _height,
      width: _width - _iconWidth,
      child: ValueListenableBuilder(
          valueListenable: SwitchGameListBloc.switchGameOrderNoti,
          builder: _orderListBuilder),
    ),
    Container(
        width: _iconWidth,
        margin: EdgeInsets.only(top: 4),
        alignment: Alignment.centerLeft,
        color: Colors.transparent,
        child: GestureDetector(
          child: ValueListenableBuilder(
            valueListenable: SwitchGameListBloc.iconIsOn,
            builder: (_, bool _isOn, __) {
              if (_isOn) {
                return Icon(
                  Icons.bookmark,
                  color: Colors.green,
                  size: 40,
                );
              }

              return Icon(
                Icons.bookmark,
                color: Colors.orange,
                size: 40,
              );
            },
          ),
          onTap: () {
            AnalyticsBloc.observer.analytics
                .setCurrentScreen(screenName: "/tag_dialog");
            showDialog(context: context, builder: _optionDetailBuilder).then(
                (value) => AnalyticsBloc.observer.analytics
                    .setCurrentScreen(screenName: "${_HomeState.routeName}"));
          },
        ))
  ]));
}

AlertDialog _optionDetailBuilder(BuildContext context) {
  // TODO 이거 참조해서 할거 https://stackoverflow.com/questions/53913192/flutter-change-the-width-of-an-alertdialog

  return AlertDialog(
    scrollable: true,
    content: Form(
      child: Column(children: [
        _chipList(SwitchGameListBloc.genreOptionNotifier,
            SwitchGameListBloc.languageOptionNotifier),
        Padding(
            padding: EdgeInsets.only(top: 20),
            child: ElevatedButton(
                onPressed: () => Navigator.pop(context), child: Text("확인")))
      ]),
    ),
  );
}

Column _chipList(GenreOptionNotifier genreOptionNotifier,
    LanguageOptionNotifier languageOptionNotifier) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "장르",
        style: TextStyle(fontSize: 20),
      ),
      ValueListenableBuilder(
          valueListenable: genreOptionNotifier, builder: _buildGenreChipList),
      Padding(padding: EdgeInsets.all(15)),
      Text(
        "언어",
        style: TextStyle(fontSize: 20),
      ),
      ValueListenableBuilder(
          valueListenable: languageOptionNotifier,
          builder: _buildLanguageChipList),
    ],
  );
}

Wrap _buildLanguageChipList(BuildContext context, SearchOptions options, _) {
  return Wrap(
    spacing: 6.0,
    runSpacing: 6.0,
    children: Language.values.map((language) {
      return _buildLanguageChip(language, options);
    }).toList(),
  );
}

Wrap _buildGenreChipList(BuildContext context, SearchOptions options, _) {
  return Wrap(
    spacing: 6.0,
    runSpacing: 6.0,
    children: Genre.values.map((genre) {
      return _buildGenreChip(genre, options);
    }).toList(),
  );
}

ActionChip _buildLanguageChip(Language _language, SearchOptions options) {
  Color _color = Colors.orange;
  bool _selected = false;
  if (options.languages.contains(_language)) {
    _color = Colors.green;
    _selected = true;
  }

  return ActionChip(
    elevation: 6.0,
    backgroundColor: _color,
    padding: EdgeInsets.all(2.0),
    shadowColor: Colors.grey[60],
    label: Text(
      languageName[_language.index],
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    onPressed: () {
      if (_selected) {
        SwitchGameListBloc.languageOptionNotifier.removeLanguage(_language);
      } else {
        SwitchGameListBloc.languageOptionNotifier.addLanguage(_language);
      }
      log(options.languages.toString());
      SwitchGameListBloc.switchGameFilter();
    },
  );
}

ActionChip _buildGenreChip(Genre _genre, SearchOptions options) {
  Color _color = Colors.orange;
  bool _selected = false;
  if (options.genres.contains(_genre)) {
    _color = Colors.green;
    _selected = true;
  }

  return ActionChip(
    elevation: 6.0,
    backgroundColor: _color,
    padding: EdgeInsets.all(2.0),
    shadowColor: Colors.grey[60],
    label: Text(
      genreName[_genre.index],
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    onPressed: () {
      if (_selected) {
        SwitchGameListBloc.genreOptionNotifier.removeGenre(_genre);
      } else {
        SwitchGameListBloc.genreOptionNotifier.addGenre(_genre);
      }
      log(options.genres.toString());
      SwitchGameListBloc.switchGameFilter();
    },
  );
}

Center _orderListBuilder(BuildContext context, SearchOptions options, _) {
  return Center(
      child: ListView.builder(
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
            Text("${orderByName[index]}"),
            Icon(options.asc ? Icons.arrow_upward : Icons.arrow_downward)
          ],
        );
      } else {
        _butttonColor = Colors.orange;
        _child = Text("${orderByName[index]}");
      }
      return Padding(
          padding: EdgeInsets.all(3),
          child: ElevatedButton(
            onPressed: () {
              SwitchGameListBloc.switchGameOrderNoti.clicked(_order);
              SwitchGameListBloc.switchGameSortByOrder();
              analytics.logEvent(name: "order", parameters: <String, dynamic>{
                "search_order_by": SwitchGameListBloc.searchOptions.orderBy
                    .toString()
                    .split('.')
                    .last,
                "search_order":
                    SwitchGameListBloc.searchOptions.asc ? "ASC" : "DESC",
              });
            },
            child: _child,
            style:
                ElevatedButton.styleFrom(primary: _butttonColor, elevation: 10),
          ));
    },
  ));
}

_buildList() {
  return FutureBuilder(
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
