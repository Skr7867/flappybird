// import 'package:flappybirds/game/flappy_bird_game.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// import '../game/assets.dart';

// class MainMenuScreen extends StatefulWidget {
//   final FlappyBirdGame game;
//   final InterstitialAdManager adManager = InterstitialAdManager();
//   static const String id = 'mainMenu';

//   MainMenuScreen({
//     super.key,
//     required this.game,
//   });

//   @override
//   State<MainMenuScreen> createState() => _MainMenuScreenState();
// }

// class _MainMenuScreenState extends State<MainMenuScreen> {
//   late BannerAd _bannerAd;
//   bool _isBannerAdReady = false;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize the banner ad
//     _bannerAd = BannerAd(
//       adUnitId: "ca-app-pub-7730090131564483/6401687661",
//       // adUnitId: "ca-app-pub-3940256099942544/6300978111",
//       request: const AdRequest(),
//       size: AdSize.fullBanner,
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           setState(() {
//             _isBannerAdReady = true;
//           });
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           ad.dispose();
//         },
//       ),
//     );

//     _bannerAd.load();
//   }

//   @override
//   void dispose() {
//     _bannerAd.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     widget.game.pauseEngine(); // Pause the game engine when the menu is visible

//     return Scaffold(
//       body: Stack(
//         children: [
//           GestureDetector(
//             onTap: () {
//               widget.game.overlays.remove('mainMenu');
//               widget.game.resumeEngine(); // Resume the game engine
//             },
//             child: Container(
//               width: double.infinity,
//               height: double.infinity,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(Assets.menu),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Image.asset(Assets.message),
//             ),
//           ),
//           if (_isBannerAdReady)
//             Align(
//               alignment: Alignment.topCenter,
//               child: SizedBox(
//                 width: _bannerAd.size.width.toDouble(),
//                 height: _bannerAd.size.height.toDouble(),
//                 child: AdWidget(ad: _bannerAd),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class InterstitialAdManager {
//   InterstitialAd? _interstitialAd;
//   bool _isInterstitialAdReady = false;

//   bool get isInterstitialAdReady => _isInterstitialAdReady;

//   void loadInterstitialAd() {
//     InterstitialAd.load(
//       // adUnitId: 'ca-app-pub-3940256099942544/1033173712',
//       adUnitId: 'ca-app-pub-7730090131564483/7096656387',
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           _interstitialAd = ad;
//           _isInterstitialAdReady = true;
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           _isInterstitialAdReady = false;
//         },
//       ),
//     );
//   }

//   void showInterstitialAd({VoidCallback? onAdClosed}) {
//     if (_isInterstitialAdReady && _interstitialAd != null) {
//       _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (InterstitialAd ad) {
//           ad.dispose();
//           _interstitialAd = null;
//           _isInterstitialAdReady = false;
//           if (onAdClosed != null) {
//             onAdClosed();
//           }
//         },
//         onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//           ad.dispose();
//           _interstitialAd = null;
//           _isInterstitialAdReady = false;

//           if (onAdClosed != null) {
//             onAdClosed();
//           }
//         },
//       );
//       _interstitialAd!.show();
//     } else {
//       if (onAdClosed != null) {
//         onAdClosed();
//       }
//     }
//   }

//   void dispose() {
//     _interstitialAd?.dispose();
//   }
// }

import 'dart:async'; // For StreamSubscription

import 'package:flappybirds/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
  bool _isConnected = true; // For tracking internet connection status
  late StreamSubscription<InternetConnectionStatus>
      _connectionListener; // Listener for internet connection status

  @override
  void initState() {
    super.initState();

    // Start monitoring the internet connection
    _checkInternetConnection();

    // Initialize the banner ad
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-7730090131564483/6401687661",
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

  // Function to check internet connectivity and start listener
  void _checkInternetConnection() async {
    // Initial check for connection
    _isConnected = await InternetConnectionChecker().hasConnection;

    // Listen to connection status changes
    _connectionListener = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      setState(() {
        _isConnected = status == InternetConnectionStatus.connected;
      });

      if (_isConnected) {
        widget.game.resumeEngine(); // Resume the game if connected
        _bannerAd.load(); // Reload ads if reconnected
      } else {
        widget.game.pauseEngine(); // Pause the game if disconnected
      }
    });
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _connectionListener.cancel(); // Cancel the connection listener
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
              if (_isConnected) {
                widget.game.overlays.remove('mainMenu');
                widget.game.resumeEngine(); // Resume the game engine
              } else {
                // Show a dialog if there is no internet
                _showNoInternetDialog(context);
              }
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
          if (_isBannerAdReady && _isConnected)
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

  // Show no internet dialog
  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content:
            const Text('Please check your internet connection and try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
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
