import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'flappy_bird_game.dart';

class GameWithAds extends StatefulWidget {
  const GameWithAds({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameWithAdsState createState() => _GameWithAdsState();
}

class _GameWithAdsState extends State<GameWithAds> {
  late FlappyBirdGame _game;
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _game = FlappyBirdGame();
    _loadBannerAd();
  }

  // Load the banner ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId:
          "ca-app-pub-7730090131564483/6401687661", // Replace with your actual banner ad unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ('$error');
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The Flame Game
          Positioned.fill(
            child: GameWidget(game: _game),
          ),
          // Banner Ad displayed at the bottom of the screen
          if (_isBannerAdLoaded)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent,
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            ),
        ],
      ),
    );
  }
}
