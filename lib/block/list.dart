import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:argonaut_console_recommend/configs.dart';

import 'package:argonaut_console_recommend/block/api.dart';

import 'package:argonaut_console_recommend/functions/image.dart';

import 'package:argonaut_console_recommend/data_class/search.dart';
import 'package:argonaut_console_recommend/data_class/api.dart';

class SwitchGameListBloc {
  static SearchOptions _searchOptions = SearchOptions();

  int _updateCount = 0;
  final StreamController<int> update = StreamController<int>.broadcast();

  // 위에 아이템 눌렸을때 색깔 같은거 바꾸는데 사용
  final ItemOrderNotifier switchGameOrderNoti =
      ItemOrderNotifier(_searchOptions);
  // 장르 태그 눌렀을때 색 바꿀려고
  final GenreOptionNotifier genreOptionNotifier =
      GenreOptionNotifier(_searchOptions);
  // 언어 태그 눌렀을때 색 바꿀려고
  final LanguageOptionNotifier languageOptionNotifier =
      LanguageOptionNotifier(_searchOptions);

  late List<SwitchGame> _switchGameList; // 풀리스트
  List<SwitchGame> _switchGameFilteredList = []; // 필터링 && 정렬된 리스트

  get itemCount => _switchGameList.length; // 전체 아이템
  get filteredItemCount => _switchGameFilteredList.length; // 필터링된 아이템
  get filteredItems => _switchGameFilteredList;

  // 텍스트 입력 들어오면 바로바로 필터링 하려고 리스너 등록 목적
  TextEditingController textController() {
    TextEditingController _textController = TextEditingController();

    // add listener
    _textController.addListener(() {
      _searchOptions.searchText = _textController.text;
      switchGameFilter();
    });

    return _textController;
  }

  // 처음 리스트 초기화
  Future<bool> initGameList() async {
    _switchGameList = await getSwitchGameList();
    _switchGameFilteredList = List<SwitchGame>.from(_switchGameList);

    return true;
  }

  // 텍스트, 옵션을 가지고 필터링하고 나중에 정렬도
  void switchGameFilter() {
    _switchGameFilteredList = [];

    for (SwitchGame item in _switchGameList) {
      if (_searchOptions.checkItem(item)) _switchGameFilteredList.add(item);
    }

    // updateStream을 밑에 함수에서 호출함
    switchGameSortByOrder();
  }

  // 정렬
  void switchGameSortByOrder() {
    // TODO

    update.add(++_updateCount);
    log(_updateCount.toString());
  }
}
