import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsBloc {
  static void init() async {
    MobileAds.instance.initialize();
  }
}

/// before you use it, you have to run AdsBloc.init()
class BannerAdWidget extends StatefulWidget {
  final String bannerAdUnitId;

  const BannerAdWidget({Key? key, required this.bannerAdUnitId})
      : super(key: key);

  @override
  BannerAdWidgetState createState() => BannerAdWidgetState();
}

class BannerAdWidgetState extends State<BannerAdWidget> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdSize?>(
      future: AdSize.getAnchoredAdaptiveBannerAdSize(
          Orientation.portrait, MediaQuery.of(context).size.width.truncate()),
      builder: (BuildContext context, AsyncSnapshot<AdSize?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }

        // TODO 에러 처리 && 널값 처리

        BannerAd _bottomBanner = BannerAd(
          adUnitId: widget.bannerAdUnitId,
          size: snapshot.data!,
          request: AdRequest(),
          listener: BannerAdListener(
            // Called when an ad is successfully received.
            onAdLoaded: (Ad ad) => print('Ad loaded.'),
            // Called when an ad request failed.
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              // Dispose the ad here to free resources.
              ad.dispose();
              print('Ad failed to load: $error');
            },
            // Called when an ad opens an overlay that covers the screen.
            onAdOpened: (Ad ad) => print('Ad opened.'),
            // Called when an ad removes an overlay that covers the screen.
            onAdClosed: (Ad ad) => print('Ad closed.'),
            // Called when an impression occurs on the ad.
            onAdImpression: (Ad ad) => print('Ad impression.'),
          ),
        );
        _bottomBanner.load();

        return Container(
          alignment: Alignment.center,
          child: AdWidget(ad: _bottomBanner),
          width: _bottomBanner.size.width.toDouble(),
          height: _bottomBanner.size.height.toDouble(),
        );
      },
    );
  }
}
