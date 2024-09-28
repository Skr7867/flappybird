// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flappybirds/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../game/assets.dart';

class MainMenuScreen extends StatefulWidget {
  final FlappyBirdGame game;
  final InterstitialAdManager adManager = InterstitialAdManager();
  static const String id = 'mainMenu';
  MainMenuScreen({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();

    // Initialize the banner ad
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-7730090131564483/6401687661",
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('BannerAd failed to load: $error');
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
    widget.game.pauseEngine(); // Pause the game engine when the menu is visible

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              widget.game.overlays.remove('mainMenu');
              widget.game.resumeEngine(); // Resume the game engine
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.menu), fit: BoxFit.cover),
              ),
              child: Image.asset(Assets.message),
            ),
          ),
          if (_isBannerAdReady)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            ),
        ],
      ),
    );
  }
}

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  bool get isInterstitialAdReady => _isInterstitialAdReady;

  // Load the interstitial ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-7730090131564483/7096656387', // Replace with your actual ad unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          print('Interstitial Ad loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load interstitial ad: $error');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  // Show the interstitial ad with an optional onAdClosed callback
  void showInterstitialAd({VoidCallback? onAdClosed}) {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _interstitialAd = null; // Reset the interstitial ad
          _isInterstitialAdReady = false; // Mark ad as not ready
          if (onAdClosed != null) {
            onAdClosed(); // Call the provided callback after the ad is closed
          }
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _interstitialAd = null; // Reset the ad
          _isInterstitialAdReady = false;
          print('Ad failed to show: $error');
          if (onAdClosed != null) {
            onAdClosed(); // Still call the callback to proceed with restart
          }
        },
      );
      _interstitialAd!.show();
    } else {
      print('Interstitial ad is not ready.');
      if (onAdClosed != null) {
        onAdClosed(); // Call the callback if the ad wasn't ready
      }
    }
  }

  // Dispose the interstitial ad when not needed
  void dispose() {
    _interstitialAd?.dispose();
  }
}
