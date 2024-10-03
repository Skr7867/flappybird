import 'package:connectivity_plus/connectivity_plus.dart'; // Add this
import 'package:flappybirds/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../game/assets.dart';

class MainMenuScreen extends StatefulWidget {
  final FlappyBirdGame game;
  final InterstitialAdManager adManager = InterstitialAdManager();
  static const String id = 'mainMenu';

  MainMenuScreen({
    super.key,
    required this.game,
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();

    _checkInternetConnection(); // Check internet connection

    // Initialize the banner ad
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-7730090131564483/6401687661",
      // adUnitId: "ca-app-pub-3940256099942544/6300978111",
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  // Function to check for internet connectivity
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _showSnackBar("No internet connection. Please turn on your internet.");
      // Prevent further interaction if no internet
    }
  }

  // Show Snackbar message
  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                  image: AssetImage(Assets.menu),
                  fit: BoxFit.cover,
                ),
              ),
              child: Image.asset(Assets.message),
            ),
          ),
          if (_isBannerAdReady)
            Align(
              alignment: Alignment.topCenter,
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

  void loadInterstitialAd() {
    InterstitialAd.load(
      // adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      adUnitId: 'ca-app-pub-7730090131564483/7096656387',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdClosed}) {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          if (onAdClosed != null) {
            onAdClosed();
          }
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;

          if (onAdClosed != null) {
            onAdClosed();
          }
        },
      );
      _interstitialAd!.show();
    } else {
      if (onAdClosed != null) {
        onAdClosed();
      }
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
