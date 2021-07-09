class Recommendation {
  int? _idx;
  String? _title;
  List<String>? _genre;
  String? _releaseDate;
  String? _description;
  List<String>? _languages;
  String? _playerCount;
  String? _thumbnailUrl;
  List<String>? _imageUrls;
  int? _recommended;
  int? _reviews;
  int? _score;
  double? _sentiment;
  String? _wordcloudUrl;
  NintendoStore? _nintendoStore;
  Coupang? _coupang;

  Recommendation(
      {int? idx,
      String? title,
      List<String>? genre,
      String? releaseDate,
      String? description,
      List<String>? languages,
      String? playerCount,
      String? thumbnailUrl,
      List<String>? imageUrls,
      int? recommended,
      int? reviews,
      int? score,
      double? sentiment,
      String? wordcloudUrl,
      NintendoStore? nintendoStore,
      Coupang? coupang}) {
    this._idx = idx;
    this._title = title;
    this._genre = genre;
    this._releaseDate = releaseDate;
    this._description = description;
    this._languages = languages;
    this._playerCount = playerCount;
    this._thumbnailUrl = thumbnailUrl;
    this._imageUrls = imageUrls;
    this._recommended = recommended;
    this._reviews = reviews;
    this._score = score;
    this._sentiment = sentiment;
    this._wordcloudUrl = wordcloudUrl;
    this._nintendoStore = nintendoStore;
    this._coupang = coupang;
  }

  int? get idx => _idx;
  String? get title => _title;
  List<String>? get genre => _genre;
  String? get releaseDate => _releaseDate;
  String? get description => _description;
  List<String>? get languages => _languages;
  String? get playerCount => _playerCount;
  String? get thumbnailUrl => _thumbnailUrl;
  List<String>? get imageUrls => _imageUrls;
  int? get recommended => _recommended;
  int? get reviews => _reviews;
  int? get score => _score;
  double? get sentiment => _sentiment;
  String? get wordcloudUrl => _wordcloudUrl;
  NintendoStore? get nintendoStore => _nintendoStore;
  Coupang? get coupang => _coupang;

  Recommendation.fromJson(Map<String, dynamic> json) {
    _idx = json['idx'];
    _title = json['title'];
    _genre = json['genre'].cast<String>();
    _releaseDate = json['release_date'];
    _description = json['description'];
    _languages = json['languages'].cast<String>();
    _playerCount = json['player_count'];
    _thumbnailUrl = json['thumbnailUrl'];
    _imageUrls = json['imageUrls'].cast<String>();
    _recommended = json['recommended'];
    _reviews = json['reviews'];
    _score = json['score'];
    _sentiment = json['sentiment'];
    _wordcloudUrl = json['wordcloudUrl'];
    _nintendoStore = json['nintendoStore'] != null
        ? new NintendoStore.fromJson(json['nintendoStore'])
        : null;
    _coupang =
        json['coupang'] != null ? new Coupang.fromJson(json['coupang']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idx'] = this._idx;
    data['title'] = this._title;
    data['genre'] = this._genre;
    data['release_date'] = this._releaseDate;
    data['description'] = this._description;
    data['languages'] = this._languages;
    data['player_count'] = this._playerCount;
    data['thumbnailUrl'] = this._thumbnailUrl;
    data['imageUrls'] = this._imageUrls;
    data['recommended'] = this._recommended;
    data['reviews'] = this._reviews;
    data['score'] = this._score;
    data['sentiment'] = this._sentiment;
    data['wordcloudUrl'] = this._wordcloudUrl;
    if (this._nintendoStore != null) {
      data['nintendoStore'] = this._nintendoStore?.toJson();
    }
    if (this._coupang != null) {
      data['coupang'] = this._coupang?.toJson();
    }
    return data;
  }
}

class NintendoStore {
  String? _url;
  String? _price;
  int? _salePrice;
  int? _salePeriod;

  NintendoStore({String? url, String? price, int? salePrice, int? salePeriod}) {
    this._url = url;
    this._price = price;
    this._salePrice = salePrice;
    this._salePeriod = salePeriod;
  }

  String? get url => _url;
  String? get price => _price;
  int? get salePrice => _salePrice;
  int? get salePeriod => _salePeriod;

  NintendoStore.fromJson(Map<String, dynamic> json) {
    _url = json['URL'];
    _price = json['price'];
    _salePrice = json['sale_price'];
    _salePeriod = json['sale_period'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['URL'] = this._url;
    data['price'] = this._price;
    data['sale_price'] = this._salePrice;
    data['sale_period'] = this._salePeriod;
    return data;
  }
}

class Coupang {
  String? _url;
  bool? _partner;
  String? _price;
  String? _salePrice;

  Coupang({String? url, bool? partner, String? price, String? salePrice}) {
    this._url = url;
    this._partner = partner;
    this._price = price;
    this._salePrice = salePrice;
  }

  String? get url => _url;
  bool? get partner => _partner;
  String? get price => _price;
  String? get salePrice => _salePrice;

  Coupang.fromJson(Map<String, dynamic> json) {
    _url = json['URL'];
    _partner = json['partner'];
    _price = json['price'];
    _salePrice = json['sale_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['URL'] = this._url;
    data['partner'] = this._partner;
    data['price'] = this._price;
    data['sale_price'] = this._salePrice;
    return data;
  }
}
