import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';

import 'package:console_game_db/block/analytics.dart' show AnalyticsBloc;
import 'package:console_game_db/block/list.dart' show SwitchGameListBloc;
import 'package:console_game_db/data_class/search.dart';
import 'package:flutter/rendering.dart';

final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier<bool>(false);

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

ValueListenableBuilder _searchFilterBuilder(
    BuildContext context, SearchFilter _searchFilter, _) {
  return ValueListenableBuilder<bool>(
      valueListenable: _isExpandedNotifier,
      builder: (BuildContext context, bool _isExpanded, _) {
        List<Widget> _arr = [_filterListBuilder(context)];

        if (_searchFilter.filterOptions != null) {
          _arr.add(_filterBarBuilder(_searchFilter.filterOptions!));
        }

        if (_isExpanded) {
          _arr.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ElevatedButton(
                    onPressed: SwitchGameListBloc.clear,
                    child: Text("필터 초기화"),
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                  )),
              IconButton(
                  icon: Icon(Icons.arrow_drop_up, size: 32),
                  padding: EdgeInsets.only(right: 20),
                  onPressed: () {
                    SwitchGameListBloc.searchOptions.clearFilterOption();
                    _isExpandedNotifier.value = false;
                  })
            ],
          ));
        }

        return Column(
          children: _arr,
        );
      });
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
        builder: _buildGenreChipWrap),
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
        builder: _buildLanguageChipWrap),
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
        builder: _buildConsoleChipWrap),
  );
}

ValueListenableBuilder _filterListBuilder(BuildContext context) {
  return ValueListenableBuilder<bool>(
      valueListenable: _isExpandedNotifier,
      builder: (BuildContext context, bool _isExpanded, _) {
        if (!_isExpanded) {
          return Row(children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 60,
              alignment: Alignment.center,
              color: Colors.white,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: filterOptionsName.length,
                  itemBuilder: _filterListItemBuilder),
            ),
            IconButton(
              icon: Icon(Icons.arrow_drop_down, size: 32),
              onPressed: () {
                _isExpandedNotifier.value = true;
              },
            )
          ]);
        } else {
          return Container(
            alignment: Alignment.center,
            color: Colors.white,
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width / 100),
              itemCount: filterOptionsName.length,
              itemBuilder: _filterListItemBuilder,
            ),
          );
        }
      });
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
    child: Row(children: [
      Padding(
          padding: EdgeInsets.fromLTRB(2, 8, 2, 8),
          child: Container(
              color: _backgroundColor,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
              child: Text("${filterOptionsName[index]}",
                  style: TextStyle(
                    color: _textColor,
                  ))))
    ]),
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

Padding _buildChipWrap(List<Widget> _children) {
  return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        children: _children,
      ));
}

Padding _buildConsoleChipWrap(BuildContext context, SearchFilter options, _) {
  return _buildChipWrap(Console.values.map((console) {
    return _buildConsoleChip(console, options);
  }).toList());
}

Padding _buildLanguageChipWrap(BuildContext context, SearchFilter options, _) {
  return _buildChipWrap(Language.values.map((language) {
    return _buildLanguageChip(language, options);
  }).toList());
}

Padding _buildGenreChipWrap(BuildContext context, SearchFilter options, _) {
  return _buildChipWrap(Genre.values.map((genre) {
    return _buildGenreChip(genre, options);
  }).toList());
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
    padding: EdgeInsets.all(2),
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
          SwitchGameListBloc.languageOptionNotifier.remove(_language);
        } else {
          SwitchGameListBloc.languageOptionNotifier.add(_language);
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
        SwitchGameListBloc.genreOptionNotifier.remove(_genre);
      } else {
        SwitchGameListBloc.genreOptionNotifier.add(_genre);
      }
      log(options.genres.toString());
      SwitchGameListBloc.switchGameFilter();
    },
  );
}
