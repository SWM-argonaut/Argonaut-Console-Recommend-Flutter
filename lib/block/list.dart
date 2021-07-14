import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:argonaut_console_recommend/configs.dart';

import 'package:argonaut_console_recommend/block/api.dart';

import 'package:argonaut_console_recommend/functions/sort.dart';
import 'package:argonaut_console_recommend/functions/text.dart';

import 'package:argonaut_console_recommend/data_class/search.dart';
import 'package:argonaut_console_recommend/data_class/api.dart';

class SwitchGameListBloc {
  static SearchOptions _searchOptions = SearchOptions();
  static bool _init = false;

  static int _updateCount = 0;
  static StreamController<int> update = StreamController<int>.broadcast();
  static ValueNotifier<bool> iconIsOn = ValueNotifier<bool>(false);

  // TODO: 이것들 없애고 블럭 내에서 처리하도록 바꿔야 될듯.
  // 위에 아이템 눌렸을때 색깔 같은거 바꾸는데 사용
  static ItemOrderNotifier switchGameOrderNoti =
      ItemOrderNotifier(_searchOptions);
  // 장르 태그 눌렀을때 색 바꿀려고
  static GenreOptionNotifier genreOptionNotifier =
      GenreOptionNotifier(_searchOptions);
  // 언어 태그 눌렀을때 색 바꿀려고
  static LanguageOptionNotifier languageOptionNotifier =
      LanguageOptionNotifier(_searchOptions);

  static late List<SwitchGame> _switchGameList; // 풀리스트
  static List<SwitchGame> _switchGameFilteredList = []; // 필터링 && 정렬된 리스트

  static bool get init => _init;
  static SearchOptions get searchOptions => _searchOptions;
  static int get itemCount => _switchGameList.length; // 전체 아이템
  static int get filteredItemCount =>
      _switchGameFilteredList.length; // 필터링된 아이템
  static List<SwitchGame> get filteredItems => _switchGameFilteredList;

  // 텍스트 입력 들어오면 바로바로 필터링 하려고 리스너 등록 목적
  static TextEditingController textController() {
    TextEditingController _textController = TextEditingController();

    // add listener
    _textController.addListener(() {
      _searchOptions.searchText = _textController.text;
      _searchOptions.searchTextLowerCase = textForSearch(_textController.text);
      switchGameFilter();
    });

    return _textController;
  }

  // 처음 리스트 초기화
  static Future<bool> initGameList() async {
    _switchGameList = await getSwitchGameList();
    _switchGameFilteredList = List<SwitchGame>.from(_switchGameList);

    _init = true;
    return true;
  }

  // 텍스트, 옵션을 가지고 필터링하고 나중에 정렬도
  static void switchGameFilter() {
    _switchGameFilteredList = [];

    for (SwitchGame item in _switchGameList) {
      if (_searchOptions.checkItem(item)) _switchGameFilteredList.add(item);
    }

    if (_searchOptions.languages.length + _searchOptions.genres.length == 0) {
      iconIsOn.value = false;
    } else {
      iconIsOn.value = true;
    }

    // updateStream을 밑에 함수에서 호출함
    switchGameSortByOrder();
  }

  // 정렬
  static void switchGameSortByOrder() {
    // 정보가 없는건 최하단으로
    switch (_searchOptions.orderBy) {
      case OrderBy.REVIEWS:
        _switchGameFilteredList
            .sort((a, b) => orderByReviews(a, b, _searchOptions.asc));
        break;
      case OrderBy.RELEASEDATE:
        _switchGameFilteredList
            .sort((a, b) => orderByReleasedate(a, b, _searchOptions.asc));
        break;
      case OrderBy.PRICE:
        _switchGameFilteredList
            .sort((a, b) => orderByPrice(a, b, _searchOptions.asc));
        break;
      case OrderBy.SCORE:
        _switchGameFilteredList
            .sort((a, b) => orderByScore(a, b, _searchOptions.asc));
        break;
      default:
        log("order not founded : ${_searchOptions.orderBy}");
    }

    // 배열 바뀐거 알려주는 스트림
    update.add(++_updateCount);
    log("list updated : " +
        _updateCount.toString() +
        ", order : " +
        (_searchOptions.asc ? "ASC" : "DESC") +
        ", by : " +
        _searchOptions.orderBy.toString().split(".").last);
  }
}
