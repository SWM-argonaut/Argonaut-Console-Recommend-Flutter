import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';

import 'package:argonaut_console_recommend/block/analytics.dart'
    show AnalyticsBloc;
import 'package:argonaut_console_recommend/block/list.dart'
    show SwitchGameListBloc;
import 'package:argonaut_console_recommend/data_class/search.dart';
import 'package:flutter/rendering.dart';

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({Key? key}) : super(key: key);

  @override
  SearchFilterState createState() => SearchFilterState();
}

class SearchFilterState extends State<SearchFilterBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ValueListenableBuilder(
      valueListenable: SwitchGameListBloc.filterOptionNotifier,
      builder: _searchFilterBuilder,
    ));
  }
}

Widget _searchFilterBuilder(
    BuildContext context, SearchFilter _searchFilter, _) {
  if (_searchFilter.filterOptions == null) {
    return _filterListBuilder(context);
  }

  return Column(
    children: [
      _filterListBuilder(context),
      _filterBarBuilder(_searchFilter.filterOptions!),
    ],
  );
}

Container _filterBarBuilder(FilterOptions _filter) {
  return [
    _orderBar(),
    _genreBar(),
    _langaugeBar(),
  ].elementAt(_filter.index);
}

// 오더리스트
Container _orderBar() {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(horizontal: BorderSide(color: Colors.grey))),
    child: ValueListenableBuilder(
        valueListenable: SwitchGameListBloc.switchGameOrderNoti,
        builder: _orderListBuilder),
  );
}

Container _genreBar() {
  return Container(
    height: 250,
    alignment: Alignment.center,
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(horizontal: BorderSide(color: Colors.grey))),
    child: ValueListenableBuilder(
        valueListenable: SwitchGameListBloc.genreOptionNotifier,
        builder: _buildGenreChipList),
  );
}

Container _langaugeBar() {
  return Container(
    height: 200,
    alignment: Alignment.center,
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(horizontal: BorderSide(color: Colors.grey))),
    child: ValueListenableBuilder(
        valueListenable: SwitchGameListBloc.languageOptionNotifier,
        builder: _buildLanguageChipList),
  );
}

Container _filterListBuilder(BuildContext context) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    color: Colors.white,
    child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: filterOptionsName.length,
        itemBuilder: _filterListItemBuilder),
  );
}

GestureDetector _filterListItemBuilder(BuildContext context, int index) {
  FilterOptions _filterOptions = FilterOptions.values[index];
  Color _backgroundColor, _textColor;

  if (SwitchGameListBloc.searchOptions.filterOptions == _filterOptions) {
    _backgroundColor = Colors.green;
    _textColor = Colors.white;
  } else {
    _backgroundColor = Colors.transparent;
    _textColor = Colors.black;
  }

  return GestureDetector(
    child: Padding(
        padding: EdgeInsets.fromLTRB(2, 8, 2, 8),
        child: Container(
            color: _backgroundColor,
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
            child: Text("${filterOptionsName[index]}",
                style: TextStyle(
                  color: _textColor,
                )))),
    onTap: () {
      SwitchGameListBloc.filterOptionNotifier.clicked(_filterOptions);
    },
  );
}

Center _orderListBuilder(BuildContext context, __, _) {
  return Center(
      child: ListView.builder(
    shrinkWrap: true,
    itemCount: OrderBy.values.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context, int index) {
      OrderBy _order = OrderBy.values[index];
      Color _backgroundColor, _textColor;

      if (SwitchGameListBloc.searchOptions.orderBy == _order) {
        _backgroundColor = Colors.green;
        _textColor = Colors.white;
      } else {
        _backgroundColor = Colors.transparent;
        _textColor = Colors.black;
      }
      return Padding(
          padding: EdgeInsets.fromLTRB(2, 8, 2, 8),
          child: Container(
              color: _backgroundColor,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
              child: GestureDetector(
                child: Text("${orderByName[index]}",
                    style: TextStyle(
                      color: _textColor,
                    )),
                onTap: () {
                  SwitchGameListBloc.switchGameOrderNoti.clicked(_order);
                  SwitchGameListBloc.switchGameSortByOrder();
                  AnalyticsBloc.onChangeOrder();
                },
              )));
    },
  ));
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
      Padding(padding: EdgeInsets.all(15)),
      Text(
        "언어",
        style: TextStyle(fontSize: 20),
      ),
    ],
  );
}

Wrap _buildLanguageChipList(BuildContext context, SearchFilter options, _) {
  return Wrap(
    spacing: 6.0,
    runSpacing: 6.0,
    children: Language.values.map((language) {
      return _buildLanguageChip(language, options);
    }).toList(),
  );
}

Wrap _buildGenreChipList(BuildContext context, SearchFilter options, _) {
  return Wrap(
    spacing: 6.0,
    runSpacing: 6.0,
    children: Genre.values.map((genre) {
      return _buildGenreChip(genre, options);
    }).toList(),
  );
}

ActionChip _buildLanguageChip(Language _language, SearchFilter options) {
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

ActionChip _buildGenreChip(Genre _genre, SearchFilter options) {
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
