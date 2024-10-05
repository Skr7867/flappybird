// import 'package:flame/game.dart';
// import 'package:flappybirds/game/flappy_bird_game.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// import 'leaderboard/profile_page.dart';
// import 'screens/game_over_screen.dart';
// import 'screens/main_menu_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   MobileAds.instance.initialize();

//   final game = FlappyBirdGame();
//   runApp(
//     GameWidget(
//       game: game,
//       initialActiveOverlays: const ['mainMenu'],
//       overlayBuilderMap: {
//         'mainMenu': (context, _) => MainMenuScreen(game: game),
//         'gameOver': (context, _) => GameOverScreen(game: game),
//         'profilePage': (context, _) => ProfilePage(game: game),
//       },
//     ),
//   );
// }

// class InterstitialAdManager {
//   InterstitialAd? interstitialAd;
//   bool isInterstitialAdReady = false;

//   void loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: 'ca-app-pub-7730090131564483/7096656387',
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           interstitialAd = ad;
//           isInterstitialAdReady = true;
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           isInterstitialAdReady = false;
//         },
//       ),
//     );
//   }

//   void showInterstitialAd({required Null Function() onAdClosed}) {
//     if (isInterstitialAdReady && interstitialAd != null) {
//       interstitialAd!.show();
//       interstitialAd = null;
//       isInterstitialAdReady = false;
//     }
//   }

//   void dispose() {
//     interstitialAd?.dispose();
//   }
// }

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'game/flappy_bird_game.dart';
import 'leaderboard/profile_page.dart';
import 'screens/game_over_screen.dart';
import 'screens/main_menu_screen.dart';
import 'widgets/game_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  final game = FlappyBirdGame();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
      ],
      child: MyApp(game: game),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FlappyBirdGame game;

  const MyApp({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
              initialActiveOverlays: const ['mainMenu'],
              overlayBuilderMap: {
                'mainMenu': (context, _) => MainMenuScreen(game: game),
                'gameOver': (context, _) => GameOverScreen(game: game),
                'profilePage': (context, _) => ProfilePage(game: game),
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Consumer<GameState>(
                builder: (context, gameState, child) {
                  return gameState.isBannerAdLoaded
                      ? Container(
                          height: gameState.bannerAd.size.height.toDouble(),
                          child: AdWidget(ad: gameState.bannerAd),
                        )
                      : const SizedBox.shrink(); // No ad when not loaded
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InterstitialAdManager {
  InterstitialAd? interstitialAd;
  bool isInterstitialAdReady = false;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-7730090131564483/7096656387',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          isInterstitialAdReady = false;
        },
      ),
    );
  }

  void showInterstitialAd({required VoidCallback onAdClosed}) {
    if (isInterstitialAdReady && interstitialAd != null) {
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          interstitialAd = null;
          isInterstitialAdReady = false;
          onAdClosed();
        },
      );
      interstitialAd!.show();
    }
  }

  void dispose() {
    interstitialAd?.dispose();
  }
}
