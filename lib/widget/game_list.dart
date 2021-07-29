import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:console_game_db/block/list.dart';
import 'package:console_game_db/data_class/switch_game.dart';

import 'package:console_game_db/functions/image.dart';
import 'package:console_game_db/functions/number.dart';

import 'package:console_game_db/page/detail.dart';

class GameListWidget extends StatefulWidget {
  final double height;

  const GameListWidget({Key? key, required this.height}) : super(key: key);

  @override
  _GameListWidgetState createState() => _GameListWidgetState();
}

class _GameListWidgetState extends State<GameListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height - 60,
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
                            setState(() {
                              SwitchGameListBloc.initGameList();
                            });
                          },
                          icon: Icon(Icons.restart_alt),
                        )
                      ]);
                }
                if (snapshot.data! == false) {
                  return Center(child: CircularProgressIndicator());
                }
                if (SwitchGameListBloc.itemCount == 0) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("서버와 통신이 되지 않습니다.")),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              SwitchGameListBloc.initGameList();
                            });
                          },
                          icon: Icon(Icons.restart_alt),
                        )
                      ]);
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
