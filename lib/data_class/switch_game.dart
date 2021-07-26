import 'package:console_game_db/data_class/search.dart';
import 'package:console_game_db/functions/text.dart';

// TODO 할인률 넣으면 좋을듯

Set<Genre> genreListToSet(List<String> _genres) {
  Set<Genre> _tmp = Set<Genre>();

  for (String _genre in _genres) {
    int index = genreName.indexWhere((element) => element == _genre);
    _tmp.add(index != -1 ? Genre.values[index] : Genre.ETC);
  }

  return _tmp;
}

Set<Language> languageListToSet(List<String> _languages) {
  Set<Language> _tmp = Set<Language>();

  for (String _language in _languages) {
    int index = languageName.indexWhere((element) => element == _language);
    if (index != -1) {
      _tmp.add(Language.values[index]);
    }
  }

  return _tmp;
}

class SwitchGame {
  String? _title;
  String? _titleForSearch;
  String? _idx;
  Set<Genre>? _genres;
  Set<Language>? _languages;
  String? _playerCount;
  DateTime? _releaseDate;
  List<String>? _images;
  SalePeriod? _salePeriod;
  NintendoStore? _nintendoStore;
  Coupang? _coupang;

  SwitchGame(
      {String? title,
      String? idx,
      Set<Genre>? genres,
      Set<Language>? languages,
      String? playerCount,
      DateTime? releaseDate,
      List<String>? images,
      SalePeriod? salePeriod,
      NintendoStore? nintendoStore,
      Coupang? coupang}) {
    assert(idx != null && title != null);

    this._title = title;
    this._titleForSearch = textForSearch(title!);
    this._idx = idx;
    this._genres = genres;
    this._languages = languages;
    this._playerCount = playerCount;
    this._releaseDate = releaseDate;
    this._images = images;
    this._salePeriod = salePeriod;
    this._nintendoStore = nintendoStore;
    this._coupang = coupang;
  }

  String? get title => _title;
  String? get titleForSearch => _titleForSearch;
  String? get idx => _idx;
  Set<Genre>? get genres => _genres;
  Set<Language>? get languages => _languages;
  String? get playerCount => _playerCount;
  DateTime? get releaseDate => _releaseDate;
  List<String>? get images => _images;
  SalePeriod? get salePeriod => _salePeriod;
  NintendoStore? get nintendoStore => _nintendoStore;
  Coupang? get coupang => _coupang;

  SwitchGame.fromJson(Map<String, dynamic> json) {
    assert(json['idx'] != null && json['title'] != null);

    _title = json['title'];
    _titleForSearch = textForSearch(_title!);
    _idx = json['idx'].toString();
    _genres = genreListToSet(json['genres']?.cast<String>());
    _languages = languageListToSet(json['languages']?.cast<String>());
    _playerCount = json['playerCount'];
    _images = json['images']?.cast<String>();
    _releaseDate = json['releaseDate'] != null
        ? DateTime.parse(json['releaseDate'])
        : null;
    _salePeriod = json['salePeriod'] != null
        ? new SalePeriod.fromJson(json['salePeriod'])
        : null;
    _nintendoStore = json['nintendoStore'] != null
        ? new NintendoStore.fromJson(json['nintendoStore'])
        : null;
    _coupang =
        json['coupang'] != null ? new Coupang.fromJson(json['coupang']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['idx'] = this._idx;
    data['genres'] = this._genres;
    data['languages'] = this._languages;
    data['playerCount'] = this._playerCount;
    data['images'] = this._images;
    data['releaseDate'] =
        this._releaseDate != null ? this._releaseDate.toString() : null;
    data['salePeriod'] =
        this._salePeriod != null ? this._salePeriod?.toJson() : null;
    data['nintendoStore'] =
        this._nintendoStore != null ? this._nintendoStore?.toJson() : null;
    data['coupang'] = this._coupang != null ? this._coupang?.toJson() : null;
    return data;
  }
}

class NintendoStore {
  String? _url;
  String? _description;
  int? _price;
  int? _salePrice;

  NintendoStore(
      {String? url, String? description, int? price, int? salePrice}) {
    this._url = url;
    this._description = description;
    this._price = price;
    this._salePrice = salePrice;
  }

  String? get url => _url;
  String? get description => _description;
  int? get price => _price;
  int? get salePrice => _salePrice;

  NintendoStore.fromJson(Map<String, dynamic> json) {
    _url = json['url'];
    _description = json['description'];
    _price = json['price'];
    _salePrice = json['salePrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this._url;
    data['description'] = this._description;
    data['price'] = this._price;
    data['salePrice'] = this._salePrice;
    return data;
  }
}

class Coupang {
  String? _url;
  bool? _isPartner;
  String? _title;
  int? _rating;
  int? _ratingCount;
  int? _price;
  int? _salePrice;

  Coupang(
      {String? url,
      bool? isPartner,
      String? title,
      int? rating,
      int? ratingCount,
      int? price,
      int? salePrice}) {
    this._url = url;
    this._isPartner = isPartner;
    this._title = title;
    this._rating = rating;
    this._ratingCount = ratingCount;
    this._price = price;
    this._salePrice = salePrice;
  }

  String? get url => _url;
  bool? get isPartner => _isPartner;
  String? get title => _title;
  int? get rating => _rating;
  int? get ratingCount => _ratingCount;
  int? get price => _price;
  int? get salePrice => _salePrice;

  Coupang.fromJson(Map<String, dynamic> json) {
    _url = json['url'];
    _isPartner = json['url'].contains("coupa.ng"); // 파트너스 링크는 coup.ng로 시작
    _title = json['title'];
    _rating = json['rating'];
    _ratingCount = json['ratingCount'];
    _price = json['price'];
    _salePrice = json['salePrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this._url;
    data['isPartner'] = this._isPartner;
    data['title'] = this._title;
    data['rating'] = this._rating;
    data['ratingCount'] = this._ratingCount;
    data['price'] = this._price;
    data['salePrice'] = this._salePrice;
    return data;
  }
}

class SalePeriod {
  DateTime? _start;
  DateTime? _end;

  SalePeriod({DateTime? start, DateTime? end}) {
    this._start = start;
    this._end = end;
  }

  DateTime? get start => _start;
  DateTime? get end => _end;

  SalePeriod.fromJson(Map<String, dynamic> json) {
    _start = json['start'] != null ? DateTime.parse(json['start']) : null;
    _end = json['end'] != null ? DateTime.parse(json['end']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this._start != null ? this._start.toString() : null;
    data['end'] = this._end != null ? this._end.toString() : null;
    return data;
  }
}
