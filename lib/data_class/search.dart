import 'package:flutter/material.dart';

import 'package:console_game_db/data_class/switch_game.dart';

enum OrderBy {
  REVIEWS, //리뷰 수
  RELEASEDATE, //발매 순
  PRICE, // 가격
  SCORE, //평점 순
}
const List<String> orderByName = [
  '리뷰 수',
  '발매일',
  '가격',
  '평점',
];
enum Genre {
  AOS,
  RPG,
  FIGHT,
  RACING,
  BOARD,
  SHOOTING,
  SPORT,
  SIMULATION,
  USEFUL,
  ARCADE,
  ACTION,
  ADVENTURE,
  MUSIC,
  TACTIC,
  COMMUNICATION,
  PARTY,
  PUZZLE,
  TRAINING,
  LEARNING,
  ETC,
}
const List<String> genreName = [
  'AOS',
  'RPG',
  '격투',
  '레이싱',
  '보드',
  '슈팅',
  '스포츠',
  '시뮬레이션',
  '실용',
  '아케이드',
  '액션',
  '어드벤처',
  '음악',
  '전략',
  '커뮤니케이션',
  '파티',
  '퍼즐',
  '트레이닝',
  '학습',
  '기타',
];
// 언어 코드 : http://help.ads.microsoft.com/#apex/18/ko/10004/-1
enum Language {
  KO,
  EN,
  DE,
  RU,
  NL,
  ES,
  IT,
  JA,
  ZH,
  PT,
  FR,
}
const List<String> languageName = [
  '한국어',
  '영어',
  '독일어',
  '러시아어',
  '네덜란드어',
  '스페인어',
  '이태리어',
  '일본어',
  '중국어',
  '포르투갈어',
  '프랑스어',
];
enum Console {
  SWITCH,
}
const List<String> consoleName = [
  '스위치',
];

enum FilterOptions {
  ORDER,
  GENRE,
  LANGUAGE,
  DISCOUNT,
  STORE,
  CONSOLE,
}
const List<String> filterOptionsName = [
  '정렬',
  '장르',
  '언어',
  '할인',
  '판매처',
  '콘솔',
];

class SearchFilter {
  FilterOptions? _filterOptions;
  final Set<Genre> _genres = Set<Genre>(); // 장르들
  final Set<Language> _languages = Set<Language>(); // 장르들

  String searchText = "";
  String searchTextLowerCase = "";
  bool _asc = false; // ASC, DESC
  bool _onDiscount = false;
  bool _hasCoupang = false;
  OrderBy _orderBy = OrderBy.RELEASEDATE;
  Console _console = Console.SWITCH;

  bool get asc => _asc;
  bool get onDiscount => _onDiscount;
  bool get hasCoupang => _hasCoupang;
  OrderBy get orderBy => _orderBy;
  Set<Genre> get genres => _genres;
  Set<Language> get languages => _languages;
  Console get console => _console;
  FilterOptions? get filterOptions => _filterOptions;

  void addGenre(Genre genre) => _genres.add(genre);
  void removeGenre(Genre genre) => _genres.remove(genre);
  void clearGenre() => _genres.clear();

  void addLanguage(Language language) => _languages.add(language);
  void removeLanguage(Language language) => _languages.remove(language);
  void clearLanguage() => _languages.clear();

  void filterClicked(FilterOptions item) {
    _filterOptions = _filterOptions != item ? item : null;
  }

  void clearFilterOption() {
    _filterOptions = null;
  }

  void orderClicked(OrderBy item) {
    if (item == _orderBy) {
      // if selected already, change just order
      _asc = !_asc;
    } else {
      _orderBy = item;
    }
  }

  void clearOrder() {
    _orderBy = OrderBy.RELEASEDATE;
    _asc = false;
  }

  void setConsle(Console item) {
    _console = item;
  }

  void setOnDiscount(bool item) {
    _onDiscount = item;
  }

  void sethasCoupang(bool item) {
    _hasCoupang = item;
  }

  bool checkItem(SwitchGame? item) {
    if (_onDiscount) {
      if (!item!.onSale) {
        return false;
      }
    }

    if (_hasCoupang) {
      if (item?.coupang == null) {
        return false;
      }
    }

    if (item!.languages!.containsAll(_languages) == false) {
      return false;
    }

    if (item.genres!.containsAll(_genres) == false) {
      return false;
    }

    if (item.titleForSearch!.contains(searchTextLowerCase) == false) {
      return false;
    }

    return true;
  }
}

// 정렬만
class FilterOptionNotifier extends ValueNotifier<SearchFilter> {
  FilterOptionNotifier(SearchFilter value) : super(value);

  void clicked(FilterOptions _filterOption) {
    value.filterClicked(_filterOption);
    notifyListeners();
  }
}

// 정렬만
class ItemOrderNotifier extends ValueNotifier<SearchFilter> {
  ItemOrderNotifier(SearchFilter value) : super(value);

  void clicked(OrderBy _order) {
    value.orderClicked(_order);
    notifyListeners();
  }

  void clear() {
    value.clearOrder();
    notifyListeners();
  }
}

// 장르
class GenreOptionNotifier extends ValueNotifier<SearchFilter> {
  GenreOptionNotifier(SearchFilter value) : super(value);

  void add(Genre genre) {
    value.addGenre(genre);
    notifyListeners();
  }

  void remove(Genre genre) {
    value.removeGenre(genre);
    notifyListeners();
  }

  void clear() {
    value.clearGenre();
    notifyListeners();
  }
}

class LanguageOptionNotifier extends ValueNotifier<SearchFilter> {
  LanguageOptionNotifier(SearchFilter value) : super(value);

  void add(Language language) {
    value.addLanguage(language);
    notifyListeners();
  }

  void remove(Language language) {
    value.removeLanguage(language);
    notifyListeners();
  }

  void clear() {
    value.clearLanguage();
    notifyListeners();
  }
}

class DiscountOptionNotifier extends ValueNotifier<SearchFilter> {
  DiscountOptionNotifier(SearchFilter value) : super(value);

  void clicked() {
    value.setOnDiscount(!value.onDiscount);
    notifyListeners();
  }

  void clear() {
    value.setOnDiscount(false);
    notifyListeners();
  }
}

class StoreOptionNotifier extends ValueNotifier<SearchFilter> {
  StoreOptionNotifier(SearchFilter value) : super(value);

  void clicked() {
    value.sethasCoupang(!value.hasCoupang);
    notifyListeners();
  }

  void clear() {
    value.sethasCoupang(false);
    notifyListeners();
  }
}

class ConsoleOptionNotifier extends ValueNotifier<SearchFilter> {
  ConsoleOptionNotifier(SearchFilter value) : super(value);

  void clicked(Console _console) {
    value.setConsle(_console);
    notifyListeners();
  }

  void clear() {
    value.setConsle(Console.SWITCH);
    notifyListeners();
  }
}
