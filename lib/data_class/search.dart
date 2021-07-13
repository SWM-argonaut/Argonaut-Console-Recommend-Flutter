import 'package:flutter/material.dart';

import 'package:argonaut_console_recommend/data_class/api.dart';

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

class SearchOptions {
  final Set<Genre> _genres = Set<Genre>(); // 장르들
  final Set<Language> _languages = Set<Language>(); // 장르들

  String searchText = "";
  String searchTextLowerCase = "";
  bool _asc = false; // ASC, DESC
  OrderBy _orderBy = OrderBy.RELEASEDATE;

  bool get asc => _asc;
  OrderBy get orderBy => _orderBy;
  Set<Genre> get genres => _genres;
  Set<Language> get languages => _languages;

  void addGenre(Genre genre) => _genres.add(genre);
  void removeGenre(Genre genre) => _genres.remove(genre);
  void clearGenre() => _genres.clear();

  void addLanguage(Language language) => _languages.add(language);
  void removeLanguage(Language language) => _languages.remove(language);
  void clearLanguage() => _languages.clear();

  void clicked(OrderBy item) {
    if (item == _orderBy) {
      // if selected already, change just order
      _asc = !_asc;
    } else {
      _orderBy = item;
    }
  }

  bool checkItem(SwitchGame? item) {
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
class ItemOrderNotifier extends ValueNotifier<SearchOptions> {
  ItemOrderNotifier(SearchOptions value) : super(value);

  void clicked(OrderBy item) {
    value.clicked(item);
    notifyListeners();
  }
}

// 장르
class GenreOptionNotifier extends ValueNotifier<SearchOptions> {
  GenreOptionNotifier(SearchOptions value) : super(value);

  void addGenre(Genre genre) {
    value.addGenre(genre);
    notifyListeners();
  }

  void removeGenre(Genre genre) {
    value.removeGenre(genre);
    notifyListeners();
  }

  void clearGenre(Genre genre) {
    value.clearGenre();
    notifyListeners();
  }
}

class LanguageOptionNotifier extends ValueNotifier<SearchOptions> {
  LanguageOptionNotifier(SearchOptions value) : super(value);

  void addLanguage(Language language) {
    value.addLanguage(language);
    notifyListeners();
  }

  void removeLanguage(Language language) {
    value.removeLanguage(language);
    notifyListeners();
  }

  void clearLanguage(Language language) {
    value.clearLanguage();
    notifyListeners();
  }
}
