import 'package:flame/game.dart';
import 'package:flappybirds/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'leaderboard/profile_page.dart';
import 'screens/game_over_screen.dart';
import 'screens/main_menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  final game = FlappyBirdGame();
  runApp(
    GameWidget(
      game: game,
      initialActiveOverlays: const ['mainMenu'],
      // Fixed this part for consistency
      overlayBuilderMap: {
        // 'checkphone': (context, _) => CheckPhoneScreen(),
        'mainMenu': (context, _) => MainMenuScreen(game: game),
        'gameOver': (context, _) => GameOverScreen(game: game),
        'profilePage': (context, _) => ProfilePage(game: game),
      },
    ),
  );
}

class InterstitialAdManager {
  InterstitialAd? interstitialAd;
  bool isInterstitialAdReady = false;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-7730090131564483/7096656387',

      // adUnitId: 'ca-app-pub-3940256099942544/1033173712',
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

  void showInterstitialAd({required Null Function() onAdClosed}) {
    if (isInterstitialAdReady && interstitialAd != null) {
      interstitialAd!.show();
      interstitialAd = null;
      isInterstitialAdReady = false;
    }
  }

  void dispose() {
    interstitialAd?.dispose();
  }
}
