class Recommendation {
  int? _idx;
  String? _title;
  String? _price;
  String? _thumbnailUrl;
  String? _imgUrl;
  String? _url;
  String? _partnerUrl;
  double? _sentiment;

  Recommendation(
      {int? idx,
      String? title,
      String? price,
      String? thumbnailUrl,
      String? imgUrl,
      String? url,
      String? partnerUrl,
      double? sentiment}) {
    this._idx = idx;
    this._title = title;
    this._price = price;
    this._thumbnailUrl = thumbnailUrl;
    this._imgUrl = imgUrl;
    this._url = url;
    this._partnerUrl = partnerUrl;
    this._sentiment = sentiment;
  }

  int? get idx => _idx;
  String? get title => _title;
  String? get price => _price;
  String? get thumbnailUrl => _thumbnailUrl;
  String? get imgUrl => _imgUrl;
  String? get url => _url;
  String? get partnerUrl => _partnerUrl;
  double? get sentiment => _sentiment;

  Recommendation.fromJson(Map<String, dynamic> json) {
    _idx = json['idx'];
    _title = json['title'];
    _price = json['price'];
    _thumbnailUrl = json['thumbnailUrl'];
    _imgUrl = json['imgUrl'];
    _url = json['url'];
    _partnerUrl = json['partnerUrl'];
    _sentiment = json['sentiment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idx'] = this._idx;
    data['title'] = this._title;
    data['price'] = this._price;
    data['thumbnailUrl'] = this._thumbnailUrl;
    data['imgUrl'] = this._imgUrl;
    data['url'] = this._url;
    data['partnerUrl'] = this._partnerUrl;
    data['sentiment'] = this._sentiment;
    return data;
  }
}
