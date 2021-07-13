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

  bool _init = false;

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
    if (_init) {
      return true;
    }

    _switchGameList = await getSwitchGameList();
    _switchGameFilteredList = List<SwitchGame>.from(_switchGameList);

    _init = true;
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
    log(_searchOptions.asc.toString());

    // 정보가 없는건 최하단으로
    switch (_searchOptions.orderBy) {
      case OrderBy.REVIEWS:
        _switchGameFilteredList.sort((a, b) {
          if (a.coupang == null) {
            return 1;
          } else if (a.coupang!.ratingCount == null) {
            return 1;
          } else if (b.coupang == null) {
            return -1;
          } else
            return (a.coupang!.ratingCount!
                    .compareTo(b.coupang!.ratingCount ?? 0)) *
                (_searchOptions.asc ? 1 : -1);
        });
        break;
      case OrderBy.RELEASEDATE:
        _switchGameFilteredList.sort((a, b) {
          if (a.releaseDate == null) {
            return 1;
          } else if (b.releaseDate == null) {
            return -1;
          } else
            return (a.releaseDate!.compareTo(b.releaseDate!)) *
                (_searchOptions.asc ? 1 : -1);
        });
        break;
      case OrderBy.PRICE:
        _switchGameFilteredList.sort((a, b) {
          if (a.nintendoStore == null) {
            return 1;
          } else if (a.nintendoStore!.price == null) {
            return 1;
          } else if (b.nintendoStore == null) {
            return -1;
          } else
            return (a.nintendoStore!.price!
                    .compareTo(b.nintendoStore!.price ?? 0)) *
                (_searchOptions.asc ? 1 : -1);
        });
        break;
      case OrderBy.SCORE:
        break;
      default:
        log("order not founded : ${_searchOptions.orderBy}");
    }

    // 배열 바뀐거 알려주는 스트림
    update.add(++_updateCount);
    log(_updateCount.toString());
  }
}
