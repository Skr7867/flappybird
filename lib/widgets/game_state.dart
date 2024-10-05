import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GameState extends ChangeNotifier {
  bool isBannerAdLoaded = false;
  late BannerAd _bannerAd;

  GameState() {
    _loadBannerAd();
  }

  // Load the banner ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-7730090131564483/6401687661",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          isBannerAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          notifyListeners();
        },
      ),
    );
    _bannerAd.load();
  }

  // Accessor for the banner ad
  BannerAd get bannerAd => _bannerAd;

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
