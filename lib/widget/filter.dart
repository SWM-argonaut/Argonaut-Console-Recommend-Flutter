import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';

import 'package:console_game_db/block/analytics.dart' show AnalyticsBloc;
import 'package:console_game_db/block/list.dart' show SwitchGameListBloc;
import 'package:console_game_db/data_class/search.dart';
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
    _discountBar(),
    _storeBar(),
    _consoleBar(),
  ].elementAt(_filter.index);
}

// 오더리스트
Container _orderBar() {
  return Container(
    height: 50,
    decoration: BoxDecoration(
      color: Colors.white,
    ),
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
    ),
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
    ),
    child: ValueListenableBuilder(
        valueListenable: SwitchGameListBloc.languageOptionNotifier,
        builder: _buildLanguageChipList),
  );
}

Container _discountBar() {
  return Container(
    height: 50,
    alignment: Alignment.center,
    // padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: ValueListenableBuilder(
        valueListenable: SwitchGameListBloc.discountOptionNotifier,
        builder: _buildDiscountChip),
  );
}

Container _storeBar() {
  return Container(
    height: 50,
    alignment: Alignment.center,
    // padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: ValueListenableBuilder(
        valueListenable: SwitchGameListBloc.storeOptionNotifier,
        builder: _buildStoreChip),
  );
}

Container _consoleBar() {
  return Container(
    height: 50,
    alignment: Alignment.center,
    // padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: ValueListenableBuilder(
        valueListenable: SwitchGameListBloc.consoleOptionNotifier,
        builder: _buildConsoleChipList),
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

Center _orderListBuilder(BuildContext context, SearchFilter filter, _) {
  return Center(
      child: ListView.builder(
    shrinkWrap: true,
    itemCount: OrderBy.values.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context, int index) {
      OrderBy _order = OrderBy.values[index];
      Color _backgroundColor;
      Widget _item;

      if (SwitchGameListBloc.searchOptions.orderBy == _order) {
        _backgroundColor = Colors.green;
        _item = Row(
          children: [
            Text("${orderByName[index]} ",
                style: TextStyle(
                  color: Colors.white,
                )),
            Icon(
              filter.asc ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
            )
          ],
        );
      } else {
        _backgroundColor = Colors.transparent;
        _item = Text("${orderByName[index]}",
            style: TextStyle(
              color: Colors.black,
            ));
      }
      return GestureDetector(
        child: Padding(
            padding: EdgeInsets.fromLTRB(2, 8, 2, 8),
            child: Container(
                color: _backgroundColor,
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
                child: _item)),
        onTap: () {
          SwitchGameListBloc.switchGameOrderNoti.clicked(_order);
          SwitchGameListBloc.switchGameSortByOrder();
          AnalyticsBloc.onChangeOrder();
        },
      );
    },
  ));
}

Wrap _buildConsoleChipList(BuildContext context, SearchFilter options, _) {
  return Wrap(
    spacing: 6.0,
    runSpacing: 6.0,
    children: Console.values.map((console) {
      return _buildConsoleChip(console, options);
    }).toList(),
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

ActionChip _buildChip({
  required bool isSelected,
  required String text,
  required void Function() onPressed,
  Color backgroundColor = Colors.orange,
  Color selectedBackgroundColor = Colors.green,
}) {
  return ActionChip(
    elevation: 6.0,
    backgroundColor: isSelected ? selectedBackgroundColor : backgroundColor,
    padding: EdgeInsets.all(2.0),
    shadowColor: Colors.grey[60],
    label: Text(
      text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    onPressed: onPressed,
  );
}

ActionChip _buildConsoleChip(Console _console, SearchFilter options) {
  return _buildChip(
    isSelected: options.console == _console,
    text: consoleName[_console.index],
    onPressed: () {
      SwitchGameListBloc.consoleOptionNotifier.clicked(_console);
    },
  );
}

ActionChip _buildDiscountChip(BuildContext context, SearchFilter options, _) {
  return _buildChip(
    isSelected: options.onDiscount,
    text: "할인중인 제품만 보기",
    onPressed: () {
      SwitchGameListBloc.discountOptionNotifier.clicked();
      SwitchGameListBloc.switchGameFilter();
    },
  );
}

ActionChip _buildStoreChip(BuildContext context, SearchFilter options, _) {
  return _buildChip(
    isSelected: options.hasCoupang,
    text: "쿠팡",
    onPressed: () {
      SwitchGameListBloc.storeOptionNotifier.clicked();
      SwitchGameListBloc.switchGameFilter();
    },
  );
}

ActionChip _buildLanguageChip(Language _language, SearchFilter options) {
  bool _isSelected = options.languages.contains(_language);
  return _buildChip(
      isSelected: _isSelected,
      text: languageName[_language.index],
      onPressed: () {
        if (_isSelected) {
          SwitchGameListBloc.languageOptionNotifier.removeLanguage(_language);
        } else {
          SwitchGameListBloc.languageOptionNotifier.addLanguage(_language);
        }
        log(options.languages.toString());
        SwitchGameListBloc.switchGameFilter();
      });
}

ActionChip _buildGenreChip(Genre _genre, SearchFilter options) {
  bool _isSelected = options.genres.contains(_genre);
  return _buildChip(
    isSelected: _isSelected,
    text: genreName[_genre.index],
    onPressed: () {
      if (_isSelected) {
        SwitchGameListBloc.genreOptionNotifier.removeGenre(_genre);
      } else {
        SwitchGameListBloc.genreOptionNotifier.addGenre(_genre);
      }
      log(options.genres.toString());
      SwitchGameListBloc.switchGameFilter();
    },
  );
}
